const functions = require("firebase-functions");
const moment = require("moment-timezone");
const { db, timeZone, typesenseCred, projectId } = require("./admin");

async function test() {
    const collections = [];
    const snapshots = await db.listCollections();
    snapshots.forEach(snaps => {
        collections.push(snaps["_queryOptions"].collectionId)
    });
    for (const collection of collections) {
        const ref = await db.collection(collection).get();
        const docs = [];
        ref.forEach(doc => {
            docs.push(doc.id);
        });
        if(docs.length > 0) {
            for (const docId of docs) {
                await db.collection(collection).doc(docId).update({
                    createdAt: new Date(moment().tz(timeZone))
                });
            }
        }
    }
}


// ? Start Create Or Import isKon In TypeSense
function typesense_initClient() {
    return new Promise((resolve, reject) => {
        try {
            const Typesense = require('typesense');
            let typesenseClient = new Typesense.Client({
                'nodes': [{
                    'host': typesenseCred.host,
                    'port': typesenseCred.port,
                    'protocol': typesenseCred.protocol
                }],
                'apiKey': typesenseCred.apiKey,
                'connectionTimeoutSeconds': 2
            });
            resolve(typesenseClient);
        } catch (error) {
            console.log('error in initializing typesense client');
            resolve(null);
        }
    })
}

async function isScriptAvailable(scriptName) {
    return new Promise(async (resolve, reject) => {
        let status = false;
        await db.collection('scripts').doc(scriptName).get().then((doc) => {
            if (doc.exists && doc.data() && doc.data().status) {
                status = true;
            }
            resolve(status);
        });
    });
}

async function makeScriptStatusAvailable(scriptName) {
    await db.collection('scripts').doc(scriptName).set({
        status: true
    });
}

function typesense_getIndex() {
    return `${projectId}-collections`;
}

async function typesense_checkCollectionExists(client, collection) {
    return new Promise(async (resolve) => {
        try {
            await client.collections(collection).retrieve().then(() => {
                    resolve(true);
                })
                .catch((error) => {
                    console.log('error in retrieving collection', error);
                    resolve(false);
                })
        } catch (error) {
            console.log('error', error);
            resolve(false);
        }
    });
}

function getRequiredData(data) {
    const {
        categoryLevel,
        ...requiredData
    } = data;
    return requiredData;
}

function prepareData(data) {
    data['keywords'] = data.keywords || [];
    return data;
}

async function typesense_createSchema(client) {
    return new Promise(async (resolve) => {
        try {
            const collection = typesense_getIndex();
            const collectionExists = await typesense_checkCollectionExists(client, collection);
            console.log('collectionExists', collectionExists);
            if (collectionExists) {
                resolve(true);
                return;
            }

            const dataCollection = {
                'name': collection,
                "enable_nested_fields": true,
                'fields': [
                    {
                        "name": ".*",
                        "type": "auto"
                    },
                ]

            }
            client.collections().create(dataCollection).then(() => {
                console.log('schema created');
                resolve(true);
            })
                .catch((error) => {
                    console.log('error in creating schema', error);
                    resolve(false);
                })

        }
        catch (error) {
            console.log("typesense_createSchema", error);
        }
    })
}

async function importIskonToTypesense() {
    // const scriptStatus = await isScriptAvailable('importIskonToTypesense');
    // if (scriptStatus) return;

    const client = await typesense_initClient();
    console.log('typeSense client initialized...');
    if (!client) return;

    await typesense_createSchema(client);

    const dataBaseCollections = ['Audios', 'Blogs', 'Events', 'News', 'Videos', 'Pictures'];
    let data = [];
    for (let collectionName of dataBaseCollections) {
        console.log("collectionName: ",collectionName);
        const collectionRef = await db.collection(collectionName).get();
        collectionRef.forEach(async (doc) => {
            if (doc && doc.id && doc.data()) {
                data.push({ ...doc.data(), id: doc.id, type: collectionName });
            }
        });
    }

    // console.log("data: ", data);
    console.log("data length: ", data.length);
    if (data.length) {
        console.log('data fetched');
        let finalData = [];
        for (let item of data) {
            let typeSenseData = getRequiredData(item);
            typeSenseData['id'] = item.id;
            typeSenseData = prepareData(typeSenseData);
            finalData.push(typeSenseData);
        }
        console.log("finalData",finalData);

        // ? Import data To TypeSense
        client.collections(typesense_getIndex()).documents().import(finalData, {
            action: 'upsert',
            dirty_values: "coerce_or_drop"
        }).then(async res => {
            console.log('data imported to typeSense successfully');
            await makeScriptStatusAvailable('importIskonToTypesense');
        }).catch(function (error) {
            console.log('error in import data to typeSense', error);
        });

    }

}

// ? End Create Or Import isKon In TypeSense

runScripts()

function runScripts() {
    importIskonToTypesense();
}