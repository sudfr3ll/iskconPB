const functions = require("firebase-functions");
const {
    db,
    projectId,
    typesenseCred
} = require('./admin');


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

function typesense_getIndex() {
    return `${projectId}-collections`;
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

async function typesense_createSchema() {
    return new Promise(async (resolve, reject) => {
        let typesenseClient = await typesense_initClient();
        if (!typesenseClient) return;
        const collection = typesense_getIndex();
        const collectionExists = await typesense_checkCollectionExists(collection);
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
        typesenseClient.collections().create(dataCollection);
        resolve(true);
    });
}

async function typesense_addDocument(data) {
    let typesenseClient = await typesense_initClient();
    if (!typesenseClient) return;
    return typesenseClient.collections(typesense_getIndex()).documents().create(data, {
        "dirty_values": "coerce_or_drop"
    });
}

async function typesense_updateDocument(data) {
    let typesenseClient = await typesense_initClient();
    if (!typesenseClient) return;
    return typesenseClient.collections(typesense_getIndex()).documents(data.id).update(data, {
        "dirty_values": "coerce_or_drop"
    });
}

async function typesense_deleteDocument(docId) {
    return new Promise(async resolve => {
        try {
            let typesenseClient = await typesense_initClient();
            if (!typesenseClient) return;
            await typesenseClient.collections(typesense_getIndex()).documents(docId).delete();
            resolve(true);
        } catch (error) {
            console.log('error in deleting documents from typesense', error);
            resolve(false);
        }
    });
}

// ? [Audios] Start Create, Update Or Delete In TypeSense
exports.createAudioInSearch = functions.firestore.document('Audios/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'Audios';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updateAudioInSearch = functions.firestore.document('Audios/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deleteAudioInSearch = functions.firestore.document("Audios/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [Audios] End Create, Update Or Delete In TypeSense

// ? [Blogs] Start Create, Update Or Delete In TypeSense
exports.createBlogInSearch = functions.firestore.document('Blogs/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'Blogs';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updateBlogInSearch = functions.firestore.document('Blogs/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deleteBlogInSearch = functions.firestore.document("Blogs/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [Blogs] End Create, Update Or Delete In TypeSense

// ? [Events] Start Create, Update Or Delete In TypeSense
exports.createEventInSearch = functions.firestore.document('Events/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'Events';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updateEventInSearch = functions.firestore.document('Events/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deleteEventInSearch = functions.firestore.document("Events/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [Events] End Create, Update Or Delete In TypeSense

// ? [News] Start Create, Update Or Delete In TypeSense
exports.createNewsInSearch = functions.firestore.document('News/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'News';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updateNewsInSearch = functions.firestore.document('News/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deleteNewsInSearch = functions.firestore.document("News/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [News] End Create, Update Or Delete In TypeSense

// ? [Videos] Start Create, Update Or Delete In TypeSense
exports.createVideoInSearch = functions.firestore.document('Videos/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'Videos';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updateVideoInSearch = functions.firestore.document('Videos/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deleteVideoInSearch = functions.firestore.document("Videos/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [Videos] End Create, Update Or Delete In TypeSense

// ? [Pictures] Start Create, Update Or Delete In TypeSense
exports.createPictureInSearch = functions.firestore.document('Pictures/{docId}').onCreate(async (snap, context) => {
    const docId = context.params.docId;
    let data = getRequiredData(snap.data());
    data['id'] = docId;
    data['type'] = 'Pictures';
    data = prepareData(data);
    await typesense_createSchema();
    await typesense_addDocument(data);
});

exports.updatePictureInSearch = functions.firestore.document('Pictures/{docId}').onUpdate(async (change, context) => {
    const docId = context.params.docId;
    let beforeData = getRequiredData(change.before.data());
    let afterData = getRequiredData(change.after.data());
    if (JSON.stringify(beforeData) !== JSON.stringify(afterData)) {
        let updatedData = { ...afterData };
        updatedData['id'] = docId;
        updatedData = prepareData(updatedData);
        await typesense_updateDocument(updatedData);
    }
});

exports.deletePictureInSearch = functions.firestore.document("Pictures/{docId}").onDelete(async (snap, context) => {
    const docId = context.params.docId;
    await typesense_deleteDocument(docId);
});
// ? [Pictures] End Create, Update Or Delete In TypeSense