const functions = require('firebase-functions');

const {
    admin,
    db
} = require('./admin');

function preparePayload(data) {
    let payload = {
        token: '',
        notification: {
            title: data.title,
            body: data.body || '',
            image: data.image || '',
        },
        "android": {
            "notification": {
                "sound": "default",
                "click_action": "FCM_PLUGIN_ACTIVITY",
            },
            "priority": "high"
        },
        "apns": {
            "payload": {
                "aps": {
                    "sound": "default",
                    "click_action": "FCM_PLUGIN_ACTIVITY",
                }
            },
            "headers": {
                "apns-priority": "10"
            }
        },
        "data": {
            "link": JSON.stringify(data.link || {})
        },
    };
    return payload;
}

async function sendNotification(receiverTokens, payload) {
    if (receiverTokens && receiverTokens.length > 0) {
        for (const token of receiverTokens) {
            payload.token = token;
            try {
                await admin.messaging().send(payload);
            } catch (error) {
                console.log(error);
            }
        }
    }
}

async function getTokens() {
    return new Promise(async (resolve, reject) => {
        let tokens = [];
        const tokensRef = await db.collection('Tokens').get();
        tokensRef.forEach(doc => {
            if (doc && doc.data()) {
                tokens.push(doc.data().token);
            }
        });
        resolve(tokens);
    });
}

exports.sendMessageNotifications = functions.firestore.document('Message/{messageId}').onCreate(async (snap, context) => {
    const data = snap.data();
    let tokens = await getTokens();
    if(!tokens || !tokens.length || !data.notifyUser) return;
    let payload = preparePayload({
        link: {},
        title: 'New Message Received!',
        body: data.messageContent,
        image: ''
    });
    await sendNotification(tokens, payload);
    return;
});


exports.sendLiveDarshanNotification = functions.firestore.document('Live/Darshan').onUpdate(async (change, context) => {
    const after = change.after.data();
    const before = change.before.data();
    if(after.active === true && before.active === false) {
        let tokens = await getTokens();
        if(!tokens || !tokens.length) return;
        let payload = preparePayload({
            link: {},
            title: 'Darshan is live now!',
            body: 'Click here to see live darshan.',
            image: ''
        });
        await sendNotification(tokens, payload);
    }
    return;
});