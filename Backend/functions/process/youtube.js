const functions = require("firebase-functions");
const {
    db,
    timeZone
} = require("./admin");

const https = require('https');

exports.getLiveVideoId = functions.https.onCall(async (data, context) => {
    try {
        const videoId = await getLiveVideoId();
        return {
            videoId,
            coverImage: videoId ? `http://img.youtube.com/vi/${videoId}/hqdefault.jpg` : ''
        };
    } catch (error) {
        console.log(error);
        return {
            videoId: '',
            coverImage: ''
        };
    }
});

async function getLiveVideoId() {
    return new Promise(async (resolve, reject) => {
        const resp = await fetchChannelData();
        let n = resp.search(/\{"videoId[\sA-Za-z0-9:"\{\}\]\[,\-_]+BADGE_STYLE_TYPE_LIVE_NOW/i);

        //If found
        if (n >= 0) {
            let videoId = resp.slice(n + 1, resp.indexOf("}", n) - 1).split("\":\"")[1];
            resolve(videoId);
            return;
        }

        //If not found, then try another method to find live video
        n = resp.search(/https:\/\/i.ytimg.com\/vi\/[A-Za-z0-9\-_]+\/hqdefault_live.jpg/i);
        if (n >= 0) {
            let videoId = resp.slice(n, resp.indexOf(".jpg", n) - 1).split("/")[4];
            resolve(videoId);
            return;
        }
        console.log('not live stream available!');
        // no streams available;
        resolve('');
    });
}

async function fetchChannelData() {
    return new Promise(async function (resolve, reject) {
        const youtubeRef = await db.collection('Settings').doc('youTube').get();
        const youtubeData = youtubeRef.data();
        https.get('https://www.youtube.com/channel/' + youtubeData.channelId, (res) => {
            let data = '';
            res.on('data', (response) => {
                data = data + response;
            });
            res.on('end', () => {
                // console.log('data', data);
                resolve(data);
            });
        }).on('error', (err) => {
            console.error(err);
            reject(err);
        });
    });
}