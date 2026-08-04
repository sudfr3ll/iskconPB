const functions = require("firebase-functions");
const moment = require("moment-timezone");
const { db, timeZone } = require("./admin");

exports.universalFirestoreTrigger = functions.firestore
    .document('{collectionId}/{docId}')
    .onCreate(async (snap, context) => {
        const collectionId = context.params.collectionId;
        const docId = context.params.docId;
        await db.collection(collectionId).doc(docId).update({
           createdAt: new Date(moment().tz(timeZone))
        });
        return null;

    });