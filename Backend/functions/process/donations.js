const functions = require("firebase-functions");
const moment = require('moment-timezone');

const {
    db,
    timeZone,
} = require('./admin');

exports.onCreateDonation = functions.firestore.document('donations/{donationId}').onCreate(async (snap, context) => {
    const donationId = context.params.donationId;
    await generateDonationId(snap.ref);
});

async function generateDonationId(donationRef) {
    const metaDataRef = db.collection('donationsMetaData').doc('metaData');
    let donationId = null;
    await db.runTransaction(t => {
        return t.get(metaDataRef)
            .then(async doc => {
                let lastDonationId = 1000;
                if (doc.exists) {
                    lastDonationId = doc.data().lastDonationId || 1000;
                }
                donationId = lastDonationId + 1;
                t.set(metaDataRef, {
                  lastDonationId: donationId
                });
                t.update(donationRef, {
                    donationId,
                    createdAt: new Date(moment().tz(timeZone))
                });                
            });
    });
}