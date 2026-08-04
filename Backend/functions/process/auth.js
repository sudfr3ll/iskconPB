const functions = require("firebase-functions");
const moment = require('moment-timezone');

const {
  db,
  timeZone,
  admin
} = require('./admin');

exports.createUser = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const userObject = {
    name: user.displayName ? user.displayName : 'guest',
    phone: user.phoneNumber ? user.phoneNumber : '',
    createdAt: new Date(moment().tz(timeZone)),
    lastAccessAt: new Date(moment().tz(timeZone)),
    role: 'user',
    profilePic: '',
    email: '',
    lowercaseName: '',
    deviceTokens: [],
    defaultAddressId: ''
  }

  db.collection('users').doc(uid).get().then(async doc => {
    if (!doc.exists) {
      await db.collection('users').doc(uid).set(userObject);
    }
  });

});