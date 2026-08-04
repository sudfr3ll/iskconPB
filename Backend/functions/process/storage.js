const functions = require('firebase-functions');
const mkdirp = require('mkdirp-promise');
const spawn = require('child-process-promise').spawn;
const path = require('path');
const os = require('os');
const fs = require('fs');

const THUMB_MAX_HEIGHT = 200;
const THUMB_MAX_WIDTH = 200;
const MOB_MAX_HEIGHT = 500;
const MOB_MAX_WIDTH = 500;
const THUMB_PREFIX = 'thumb_';
const MOB_PREFIX = 'mob_';

const {
    admin,
    db,
    bucket
} = require('./admin');



exports.generateLowResImages = functions.storage.object().onFinalize(async (object) => {
    try {
        // File and directory paths.
        const filePath = object.name;
        const contentType = object.contentType; // This is the image MIME type
        const fileDir = path.dirname(filePath);
        const fileName = path.basename(filePath);
        const thumbFilePath = path.normalize(path.join(fileDir, `${THUMB_PREFIX}${fileName}`));
        const mobileFilePath = path.normalize(path.join(fileDir, `${MOB_PREFIX}${fileName}`));
        const tempLocalFile = path.join(os.tmpdir(), filePath);
        const tempLocalDir = path.dirname(tempLocalFile);
        const tempLocalThumbFile = path.join(os.tmpdir(), thumbFilePath);
        const tempLocalMobileFile = path.join(os.tmpdir(), mobileFilePath);
        let documentId;
        let imageId;
        if (!contentType.startsWith('image/')) {
            return console.log('This is not an image.');
        }
        if (fileName.startsWith(THUMB_PREFIX)) {
            return console.log('Already a Thumbnail.');
        }
        if (fileName.startsWith(MOB_PREFIX)) {
            return console.log('Already a Mobile.');
        }
        let filePathParts = filePath.split("/");
        const storageCollectionName = filePathParts[0];
        if (storageCollectionName === 'darshan') {
            documentId = 'Darshan';
            imageId = filePathParts[2] ? filePathParts[2].split('.')[0] : null;
        } else {
            documentId = filePathParts[1];
            imageId = filePathParts[3] ? filePathParts[3].split('.')[0] : null;
        }
        if (storageCollectionName && documentId && imageId) {
            // Cloud Storage files.
            const bucket = admin.storage().bucket(object.bucket);
            const file = bucket.file(filePath);
            const thumbFile = bucket.file(thumbFilePath);
            const mobileFile = bucket.file(mobileFilePath);
            const metadata = {
                contentType: contentType,
                // To enable Client-side caching you can set the Cache-Control headers here. Uncomment below.
                'Cache-Control': 'public,max-age=3600',
            };
            await mkdirp(tempLocalDir);
            // Download file from bucket.
            await file.download({
                destination: tempLocalFile
            });
            // Generate a thumbnail using ImageMagick.
            await spawn('convert', [tempLocalFile, '-thumbnail', `${THUMB_MAX_WIDTH}x${THUMB_MAX_HEIGHT}>`, tempLocalThumbFile], {
                capture: ['stdout', 'stderr']
            });
            // Uploading the Thumbnail.
            await bucket.upload(tempLocalThumbFile, {
                destination: thumbFilePath,
                metadata: metadata
            });
            await spawn('convert', [tempLocalFile, '-thumbnail', `${MOB_MAX_WIDTH}x${MOB_MAX_HEIGHT}>`, tempLocalMobileFile], {
                capture: ['stdout', 'stderr']
            });

            // Uploading the Thumbnail.
            await bucket.upload(tempLocalMobileFile, {
                destination: mobileFilePath,
                metadata: metadata
            });
            // Once the image has been uploaded delete the local files to free up disk space.
            fs.unlinkSync(tempLocalFile);
            fs.unlinkSync(tempLocalThumbFile);
            fs.unlinkSync(tempLocalMobileFile);
            const config = {
                action: 'read',
                expires: '03-01-2500',
            };
            const results = await Promise.all([
                thumbFile.getSignedUrl(config),
                mobileFile.getSignedUrl(config),
                file.getSignedUrl(config)
            ]);
            const thumbResult = results[0];
            const mobileResult = results[1];
            const fileResult = results[2];
            const thumbFileUrl = thumbResult[0];
            const mobileUrl = mobileResult[0];
            const originalUrl = fileResult[0];

            const collectionName = getFirestoreCollectionName(storageCollectionName);
            if(collectionName === 'News') {
                const docRef = await db.collection(collectionName).doc(documentId).get();
                const docData = docRef.data();
                if(docData) {
                    const images = docData.images || [];
                    images.push({
                        'mob': mobileUrl,
                        'thumb': thumbFileUrl,
                        'org': originalUrl
                    })
                    await db.collection(collectionName).doc(documentId)
                    .update({images});
                }
                return;
            }
            let resizedImageObj = collectionName === 'Pictures' ? {
                'image.mob': mobileUrl,
                'image.thumb': thumbFileUrl,
                'image.org': originalUrl
            } : {
                resizedCoverImage: {
                    mob: mobileUrl,
                    thumb: thumbFileUrl,
                },
                coverImage: originalUrl
            };

            await db.collection(collectionName).doc(documentId)
                .update(resizedImageObj);
            return console.log('image resized');
        } else {
            return console.log("Ids invalid");
        }
    } catch (error) {
        console.log('error', error);
    }

});

function getFirestoreCollectionName(storageCollectionName) {
    let collectionName = '';
    switch (storageCollectionName) {
        case 'audios':
            collectionName = 'Audios';
            break;
        case 'blogs':
            collectionName = 'Blogs';
            break;
        case 'categoryOne':
            collectionName = 'Categories-L1';
            break;
        case 'categoryTwo':
            collectionName = 'Categories-L2';
            break;
        case 'categoryThree':
            collectionName = 'Categories-L3';
            break;
        case 'darshan':
            collectionName = 'Live';
            break;
        case 'donationTypes':
            collectionName = 'DonationTypes';
            break;
        case 'events':
            collectionName = 'Events';
            break;
        case 'festivals':
            collectionName = 'Festivals';
            break;
        case 'messages':
            collectionName = 'Message';
            break;
        case 'news':
            collectionName = 'News';
            break;
        case 'pictures':
            collectionName = 'Pictures';
            break;
        case 'videos':
            collectionName = 'Videos';
            break;
    }
    return collectionName;
}