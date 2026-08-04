const functions = require("firebase-functions");
const {
  db,
  timeZone
} = require("./admin");
const sha512 = require("js-sha512");
const axios = require('axios').default;
const moment = require('moment-timezone');
const https = require('https');

const PaytmChecksum = require('./PaytmChecksum');

// google-site-verification=MnTIZOLq3U-ku-fRUYnrikQ_j43URb-3MJLvSntmzPw
// google-site-verification=MnTIZOLq3U-ku-fRUYnrikQ_j43URb-3MJLvSntmzPw

function passTemplate(type, icon, msg, subMsg, id, amount) {
  let bg = '',
    font = ''
  if (type === 'Success') {
    bg = '#F8FAF5'
    font = '#88B04B'
  } else {
    bg = '#FFC6D2'
    font = '#DC0000'
  }
  const template = `<html>
<head>
  <link href="https://fonts.googleapis.com/css?family=Nunito+Sans:400,400i,700,900&display=swap" rel="stylesheet">
</head>
  <style>
    body {
      text-align: center;
      padding: 40px 0;
      background: #EBF0F5;
    }
      h1 {
        color: ${ font };
        font-family: "Nunito Sans", "Helvetica Neue", sans-serif;
        font-weight: 900;
        font-size: 40px;
        margin-bottom: 10px;
      }
      p {
        color: #404F5E;
        font-family: "Nunito Sans", "Helvetica Neue", sans-serif;
        font-size:20px;
        margin: 0;
      }
    i {
      color: ${ font };
      font-size: 100px;
      line-height: 200px;
      margin-left:-15px;
    }
    .card {
      background: white;
      padding: 60px;
      border-radius: 4px;
      box-shadow: 0 2px 3px #C8D0D8;
      display: inline-block;
      margin: 0 auto;
    }
  </style>
  <body>
    <div class="card">
    <div style="border-radius:200px; height:200px; width:200px; background: ${ bg }; margin:0 auto;">
      <i class="checkmark">${ icon }</i>
    </div>
      <h1>${ type }</h1> 
      <p>${ msg }<br/>${ subMsg }</p><br/>
      <p>Transaction ID - ${ id }<br/>Amount - ₹${ amount }</p>
      <p>You will be shortly redirected back to the app in 5 seconds...</p>
    </div>
  </body>
</html>`
  return template
}

// exports.payURequestModulator_Encrypt = functions.https.onCall( async ( data, context ) => {
//   try {
//       const CryptoJS = require( 'crypto-js' );
//       console.log( 'received data : ', data )
//       if ( data.type === 'encrypt' ) {
//           let plaintext = JSON.stringify( data )
//           console.log( 'plaintext : ', plaintext )
//           const passphrase = 'PayU-BWI-346';
//           let encryptedData = CryptoJS.AES.encrypt( plaintext, passphrase ).toString()
//           console.log( 'encrypted data : ', encryptedData )
//           return {
//               status: true,
//               mode: data.type,
//               data: encryptedData
//           }
//       } else if ( data.type === 'decrypt' ) {
//           // let state = ccAvenueRequestModulator_Decrypt( data )
//           // return {
//           //     status: true,
//           //     mode: data.type,
//           //     data: state
//           // }
//       }
//   } catch ( error ) {
//       return {
//           status: false,
//           pos: 'OC',
//           error
//       }
//   }
// } )

// function ccAvenueRequestModulator_Decrypt ( data ) {
//   const CryptoJS = require( 'crypto-js' );
//   const passphrase = 'PayU-BWI-346';
//   const bytes = CryptoJS.AES.decrypt( data, passphrase );
//   const originalText = bytes.toString( CryptoJS.enc.Utf8 );
//   return originalText;
// }

// exports.generateSHA512Response = functions.https.onCall( async ( data, context ) => {
//   let decryptedData
//   try {
//     // let decData = ccAvenueRequestModulator_Decrypt( data )
//     // decryptedData = JSON.parse( decData )
//     decryptedData = data
//     console.log('decryptedData : ', decryptedData)
//     if ( !decryptedData.key || !decryptedData.amount || !decryptedData.productinfo || !decryptedData.firstname || !decryptedData.email ) {
//       return ( {
//         status: false,
//         reason: 'Incomplete payload received!',
//         data: decryptedData
//       } )
//     } else {
//       const payUDoc = await db.collection( 'Integrations' ).doc( 'PayU' ).get()
//       if ( payUDoc.data().credentials && payUDoc.data().credentials.merchantId && payUDoc.data().credentials.SALT ) {
//         const SALT = payUDoc.data().credentials.SALT
//         let state = await createDonation( decryptedData )
//         if ( state.status ) {
//           let surl = `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-payUSuccessURL?oid=${ state.txnId }`
//           let curl = `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-payUCancelURL?oid=${ state.txnId }`
//           let furl = `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-payUFailURL?oid=${ state.txnId }`
//           const rawData = `${ decryptedData.key }|${ state.txnId }|${ decryptedData.amount }|${ decryptedData.productinfo }|${ decryptedData.firstname }|${ decryptedData.email }|||||||||||${ SALT }`
//           let encryptedHash = sha512( rawData );
//           if ( encryptedHash && encryptedHash.length ) {
//             return ( {
//               status: true,
//               reason: 'SHA512 encryption successful!',
//               data: decryptedData,
//               hash: encryptedHash,
//               date: new Date(),
//               redirectURL: { surl, curl, furl },
//               txnId: state.txnId
//             } )
//           } else {
//             return ( {
//               status: false,
//               reason: 'Error in encryptedHash!',
//               data: decryptedData
//             } )
//           }
//         } else {
//           return ( {
//             status: false,
//             reason: 'Error in createDonation!',
//             data: decryptedData
//           } )
//         }
//       } else {
//         return ( {
//           status: false,
//           reason: 'Incomplete DB Credentials!',
//           data: { ...decryptedData, ...payUDoc.data() }
//         } )
//       }
//     }
//   } catch ( error ) {
//     return ( {
//       status: false,
//       reason: `generateSHA512Response OC Error : ${ error }`,
//       data: decryptedData
//     } )
//   }
// } )

async function createDonation(data) {
  try {
    let donationObj = {
      userName: data.firstname + ' ' + data.lastname,
      phoneNo: data.phoneNo,
      amount: data.amount,
      createdAt: new Date(),
      donationId: 0,
      donation: {
        id: data.docId,
        name: data.productinfo
      },
      payment: {
        status: 'pending', //pending,completed/failed
        mode: '', //hdfc
        details: {},
      }
    }
    let ref = await getDonationRef()
    await db.collection('donations').doc(ref).set(donationObj)
    // await setPayUOrdersMeta(ref, donationObj.amount)
    await setCCAvenueOrdersMeta(ref, donationObj.amount)
    return {
      status: true,
      txnId: ref,
    }
  } catch (error) {
    console.log('Error in createDonation : ', error)
    return {
      status: false
    }
  }
}

// async function setPayUOrdersMeta(docId, amount) {
//   await db.collection('Integrations').doc('PayU').collection('donationsMeta').doc(docId).set({
//     createdAt: new Date(moment().tz(timeZone)),
//     amount: amount
//   })
// }

async function setCCAvenueOrdersMeta(docId, amount) {
  await db.collection('Integrations').doc('CCAvenue').collection('donationsMeta').doc(docId).set({
    createdAt: new Date(moment().tz(timeZone)),
    amount: amount
  })
}

// async function getPayUSettings() {
//   try {
//     let payUSettingsRef = await db.collection('Settings').doc('PayU').get()
//     let payUSettingsData = payUSettingsRef.data()
//     let payUIntegrationRef = await db.collection('Integrations').doc('PayU').get()
//     let payUIntegrationData = payUIntegrationRef.data()
//     return {
//       ...payUSettingsData, ...payUIntegrationData
//     }
//   } catch (error) {
//     console.log('error in getSettings : ', error)
//   }
// }

// async function clearOrdersMeta(docId) {
//   await db.collection('Integrations').doc('PayU').collection('donationsMeta').doc(docId).delete()
// }

// async function getOrdersMeta() {
//   let ordersArr = []
//   let ordersMetaRef = await db.collection('Integrations').doc('PayU').collection('donationsMeta').get()
//   if (ordersMetaRef.empty) {
//     return ordersArr
//   } else {
//     ordersMetaRef.forEach(orderDoc => {
//       ordersArr.push({docId: orderDoc.id, ...orderDoc.data()})
//     })
//     return ordersArr
//   }
// }

// async function verifyPayUPayment(txnId, amount) {
//   let pState = false
//   try {
//     let ordersMeta = await getOrdersMeta()
//     let payUdata = await getPayUSettings()
//     await axios.post(`http://139.59.18.73/api/hdfcpayu.php?var1=${txnId}&key=${payUdata.credentials.merchantId}&salt=${payUdata.credentials.SALT}&mode=${payUdata.verifyPaymentMode}`)
//     .then( async (response) => {
//       console.log('response received : ', response.data.o)
//       let res = response.data.o
//       if (res.transaction_details[txnId].status === 'success' && ordersMeta.length) {
//         for (let i = 0; i < ordersMeta.length; i++) {
//           if (ordersMeta[i].docId === txnId && (parseFloat(amount) === ordersMeta[i].amount)) {
//             await clearOrdersMeta(txnId)
//             pState = true
//             return true
//           }
//         }
//         pState = false
//         return false
//       } else {
//         console.log('verifyPayUPayment else')
//         pState = false
//         return false  
//       }
//     })
//     .catch(error => {
//       console.log('error in verifyPayUPayment IC : ', error)
//       pState = false
//       return false
//     })
//     return pState
//   } catch (error) {
//     console.log('error in verifyPayUPayment OC : ', error)
//     return false
//   }
// }

// exports.payUSuccessURL = functions.https.onRequest( async ( req, res ) => {
//   let data = req.body
//   try {
//     console.log( 'Received payUSuccessURL Data : ', data )
//     let verifyState = false
//     verifyState = await verifyPayUPayment(data.txnid, data.amount)
//     if ( verifyState && data.txnid ) {
//       console.log('Payment Success in payUSuccessURL!!!')
//       res.send(passTemplate('Success', '✓', 'Donation verified successfully!', 'Thank you so much.', data.txnid, data.amount))
//       await setOrderState(data, 'success')
//     } else {
//       console.log('Payment Failed in payUSuccessURL!!!')
//       res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
//       await setOrderState(data, 'fail')
//     }
//   } catch ( error ) {
//     // res.sendStatus(200)
//     res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
//     await setOrderState(data, 'fail')
//     console.log( 'Error in payUSuccessURL : ', error )
//   }
// } )

// exports.payUFailURL = functions.https.onRequest( async ( req, res ) => {
//   let data = req.body
//   try {
//     res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
//     console.log( 'Received payUFailURL Data : ', data )
//     if ( data.txnid ) {
//       await setOrderState(data, 'fail')
//     }
//   } catch ( error ) {
//     // res.sendStatus( 200 )
//     res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
//     await setOrderState(data, 'fail')
//     console.log( 'Error in payUFailURL : ', error )
//   }
// } )

// exports.payUCancelURL = functions.https.onRequest( async ( req, res ) => {
//   let data = req.body
//   try {
//     res.send(passTemplate('Cancel', '!', 'Donation cancelled!', 'Please try again.', data.txnid, data.amount))
//     console.log( 'Received payUCancelURL Data : ', data )
//     if ( data.txnid ) {
//       await setOrderState(data, 'cancel')
//     }
//   } catch ( error ) {
//     // res.sendStatus( 200 )
//     res.send(passTemplate('Cancel', '!', 'Donation cancelled!', 'Please try again.', data.txnid, data.amount))
//     await setOrderState(data, 'cancel')
//     console.log( 'Error in payUCancelURL : ', error )
//   }
// } )

async function setOrderState(data, state) {
  if (state === 'success') {
    await db.collection('donations').doc(data.txnid).update({
      'payment.status': 'completed',
      'payment.mode': data.payment_source,
      'payment.details': data
    })
  } else if (state === 'cancel') {
    await db.collection('donations').doc(data.txnid).update({
      'payment.status': 'cancelled',
      'payment.mode': data.payment_source,
      'payment.details': data
    })
  } else {
    await db.collection('donations').doc(data.txnid).update({
      'payment.status': 'failed',
      'payment.mode': data.payment_source,
      'payment.details': data
    })
  }
}

async function setSubscriptionState(data, state) {
  await db.collection('subscriptions').doc(data.txnid).update({
    'payment.status': state,
    'payment.mode': data.payment_source,
    'payment.details': data
  })
}

async function getDonationRef() {
  const ref = db.collection('donations').doc()
  console.log('refTest', ref.id)
  return ref.id
}

exports.processCCAvenuePayload = functions.https.onCall(async (data, context) => {
  try {
    console.log('Received Data : ', data)
    const CCAvenueDoc = await db.collection('Integrations').doc('CCAvenue').get()
    let ccAvenueCreds = CCAvenueDoc.data().credentials
    if (ccAvenueCreds.merchantId && ccAvenueCreds.workingKey && ccAvenueCreds.accessCode) {
      const nodeCCAvenue = require('node-ccavenue');
      const ccav = new nodeCCAvenue.Configure({
        merchant_id: ccAvenueCreds.merchantId,
        working_key: ccAvenueCreds.workingKey
      })
      let orderParams;
      if (data.type == 'subscriptionOneTime') {
        console.log('inside subscriptionOneTime');
        orderParams = {
          order_id: data.docId,
          currency: 'INR',
          amount: data.amount,
          redirect_url: `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-hdfcRedirectLink?orderId=${data.docId}&type=${data.type}`,
          cancel_url: `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-hdfcCancelLink?type=${data.type}`,
          language: 'EN',
          merchant_param1: 'subscriptionOneTime',
        }
      } else {
        console.log('inside else');
        let donationDocState = await createDonation(data)
        orderParams = {
          order_id: donationDocState.txnId,
          currency: 'INR',
          amount: data.amount,
          redirect_url: `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-hdfcRedirectLink?orderId=${donationDocState.txnId}`,
          cancel_url: `https://us-central1-bwi-iskon-dev.cloudfunctions.net/payments-hdfcCancelLink`,
          language: 'EN',
          // merchant_param1: '',
        }
      }
      console.log('orderParams.redirect_url: ' + orderParams.redirect_url);
      const encryptedOrderData = ccav.getEncryptedOrder(orderParams);
      return {
        status: true,
        encryptedData: encryptedOrderData,
        accessCode: ccAvenueCreds.accessCode
      }
    } else {
      return ({
        status: false,
        reason: 'Incomplete credentials received!',
        ccAvenueCreds
      })
    }
  } catch (error) {
    console.log('Error in processCCAvenuePayload : ', error)
    return ({
      status: false,
      reason: 'Error in processCCAvenuePayload !',
      error
    })
  }
})

async function localCCDecrypt(data) {
  const CCAvenueDoc = await db.collection('Integrations').doc('CCAvenue').get()
  let ccAvenueCreds = CCAvenueDoc.data().credentials
  // console.log('ccAvenueCreds', ccAvenueCreds)
  const nodeCCAvenue = require('node-ccavenue');
  const ccav = new nodeCCAvenue.Configure({
    merchant_id: ccAvenueCreds.merchantId,
    working_key: ccAvenueCreds.workingKey,
  });
  const decryptedOrderData = ccav.redirectResponseToJson(data);
  // console.log('decryptedOrderData : ', decryptedOrderData)
  return decryptedOrderData
}

exports.hdfcRedirectLink = functions.https.onRequest(async (req, res) => {
  console.log('req.query:', req.query);
  const dataReceived = req.body
  let decryptedResponse = await localCCDecrypt(dataReceived.encResp)
  let type = decryptedResponse.merchant_param1;
  console.log('type:', type);
  try {
    console.log('Received Redirect Data : ', decryptedResponse)
    let data = {
      txnid: decryptedResponse.order_id,
      payment_source: 'CCAvenue',
      ...decryptedResponse
    }
    if (decryptedResponse.order_status === 'Success') {
      // console.log('Payment successful : ', decryptedResponse)
      if (type == 'subscriptionOneTime') {
        await setSubscriptionState(data, 'completed');
        res.send(passTemplate('Success', '✓', 'Subscription Payment Done successfully!', 'Thank you so much.', data.txnid, data.amount))
      } else {
        res.send(passTemplate('Success', '✓', 'Donation verified successfully!', 'Thank you so much.', data.txnid, data.amount))
        await setOrderState(data, 'success')
      }
    } else if (decryptedResponse.order_status === 'Failure') {
      if (type == 'subscriptionOneTime') {
        await setSubscriptionState(data, 'failed');
        res.send(passTemplate('Failed', 'X', 'Subscription could not be done!', `Reason - ${decryptedResponse.status_message || 'NA' }`, data.txnid, data.amount))
      } else {
        res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', `Reason - ${decryptedResponse.status_message || 'NA' }`, data.txnid, data.amount))
        console.log('Payment failed : ', decryptedResponse)
        await setOrderState(data, 'fail')
      }
    }
  } catch (error) {
    let data = {
      txnid: decryptedResponse.order_id,
      payment_source: 'CCAvenue',
      ...decryptedResponse
    }
    if (type == 'subscriptionOneTime') {
      await setSubscriptionState(data, 'failed');
      res.send(passTemplate('Failed', 'X', 'Subscription could not be done!', 'Please try again.', data.txnid, data.amount))
    } else {
      res.send(passTemplate('Failed', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
      await setOrderState(data, 'fail')
    }
    console.log('Error in hdfcRedirectLink : ', error)
  }
})

exports.hdfcCancelLink = functions.https.onRequest(async (req, res) => {
  try {
    console.log('req.query:', req.query);
    const dataRecieved = req.body
    let type = req.query.type;
    let decryptedResponse = await localCCDecrypt(dataRecieved.encResp)
    console.log('Received Cancel Data : ', decryptedResponse)
    let data = {
      txnid: decryptedResponse.order_id,
      payment_source: 'CCAvenue',
      ...decryptedResponse
    }
    if (type == 'subscriptionOneTime') {
      await setSubscriptionState(data, 'cancelled');
      res.send(passTemplate('Cancelled', 'X', 'Subscription could not be done!', 'Please try again.', data.txnid, data.amount))
    } else {
      res.send(passTemplate('Cancelled', 'X', 'Donation could not be verified!', 'Please try again.', data.txnid, data.amount))
      await setOrderState(data, 'cancel')
    }
  } catch (error) {
    console.log('Error in hdfcCancelLink : ', error)
  }
})


exports.paytm_getTxnToken = functions.https.onCall(async (data, context) => {

  const paytmCred = await getPaytmCred();

  // const ref = db.collection('donations').doc();
  // const donationId = ref.id;
  if (!data.userId) {
    const userRef = db.collection('users').doc();
    data.userId = userRef.id;
  }

  const apiData = {
    merchantId: paytmCred.merchantId,
    key: paytmCred.key,
    isProduction: paytmCred.isProduction,
    websiteName: paytmCred.website,
    orderId: data.docId,
    uid: data.userId,
    amount: data.amount
  }
  const txnTokenRes = await getTxnToken(apiData);
  return {
    txnToken: txnTokenRes.txnToken,
    merchantId: paytmCred.merchantId,
    isStaging: !paytmCred.isProduction,
    callbackUrl: txnTokenRes.callbackUrl,
    donationId: data.docId
  };
});

async function getTxnToken(data) {
  return new Promise(resolve => {
    try {
      const paytmParams = {};
      paytmParams.body = {
        "requestType": "Payment",
        "mid": data.merchantId,
        "websiteName": data.websiteName,
        "orderId": data.orderId,
        "callbackUrl": `https://${data.isProduction ? 'securegw' : 'securegw-stage'}.paytm.in/theia/paytmCallback?ORDER_ID=${data.orderId}`,
        "txnAmount": {
          "value": data.amount,
          "currency": 'INR',
        },
        "userInfo": {
          "custId": data.uid,
        },
      };
      console.log('paytmParams.body', paytmParams.body);
      // console.log('data.key', data.key);
      PaytmChecksum.generateSignature(JSON.stringify(paytmParams.body), data.key).then(function (checksum) {
        console.log('checksum', checksum);
        paytmParams.head = {
          "signature": checksum
        };

        var post_data = JSON.stringify(paytmParams);

        var options = {
          hostname: data.isProduction ? 'securegw.paytm.in' : 'securegw-stage.paytm.in',
          port: 443,
          path: `/theia/api/v1/initiateTransaction?mid=${data.merchantId}&orderId=${data.orderId}`,
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Content-Length': post_data.length
          }
        };

        console.log('options', options);

        var response = "";
        var post_req = https.request(options, function (post_res) {
          post_res.on('data', function (chunk) {
            // console.log('chunk', chunk);
            response += chunk;
          });

          post_res.on('end', function () {
            console.log('Response: ', response);
            resolve({
              txnToken: JSON.parse(response).body.txnToken,
              callbackUrl: paytmParams.body.callbackUrl
            });
          });
        });
        post_req.write(post_data);
        post_req.end();
      });
    } catch (error) {
      console.log(error);
      resolve({
        txnToken: '',
        callbackUrl: ''
      });
    }
  });
}

async function getPaytmCred() {
  const paytmRef = await db.collection('Settings').doc('paytm').get();
  const paytm = paytmRef.data();
  const key = paytm.key;
  const merchantId = paytm.merchantId;
  const website = paytm.website;
  const isProduction = paytm.isProduction;
  return {
    key,
    merchantId,
    isProduction,
    website
  }
}

exports.paytm_txnStatusScheduler = functions.pubsub.schedule('* * * * *').timeZone(timeZone).onRun(async (context) => {
  const today = moment().tz(timeZone);
  const minutesDiff = moment(today).tz(timeZone).subtract(20, 'minutes');
  const donationsRef = await db.collection('donations').where('createdAt', '>=', minutesDiff).where('payment.mode', '==', 'paytm').where('payment.status', '==', 'pending').get();
  const subRef = await db.collection('subscriptions').where('createdAt', '>=', minutesDiff).where('payment.mode', '==', 'paytm').where('payment.status', '==', 'pending').get();
  const docs = [];
  donationsRef.forEach(doc => {
    if (doc.id) {
      docs.push({
        id: doc.id,
        type: 'donations'
      })
    }
  })
  subRef.forEach(doc => {
    if (doc.id) {
      docs.push({
        id: doc.id,
        type: 'subscriptions'
      })
    }
  })
  if (docs.length) {
    for (const doc of docs) {
      const {
        status,
        txnDetails
      } = await getPaytmPaymentStatus(doc);
      await db.collection(doc.type).doc(doc.id).update({
        'payment.status': status,
        'payment.details': txnDetails,
      });
    }
  }
});

async function getPaytmPaymentStatus(data) {
  return new Promise(async (resolve) => {
    const paytmCred = await getPaytmCred();
    const paytmParams = {};
    paytmParams.body = {
      "mid": paytmCred.merchantId,
      "orderId": data.id,
    };

    PaytmChecksum.generateSignature(JSON.stringify(paytmParams.body), paytmCred.key).then(function (checksum) {
      paytmParams.head = {
        "signature": checksum
      };
      var post_data = JSON.stringify(paytmParams);

      var options = {
        hostname: paytmCred.isProduction ? 'securegw.paytm.in' : 'securegw-stage.paytm.in',
        port: 443,
        path: '/v3/order/status',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': post_data.length
        }
      };

      var response = "";
      var post_req = https.request(options, function (post_res) {
        post_res.on('data', function (chunk) {
          response += chunk;
        });

        post_res.on('end', function () {
          const txnStatus = JSON.parse(response).body.resultInfo.resultStatus;
          const txnDetails = JSON.parse(response).body;
          let systemStatus = '';
          switch (txnStatus) {
            case 'TXN_SUCCESS':
              systemStatus = 'completed'
              break;
            case 'TXN_FAILURE':
              systemStatus = 'failed'
              break;
            case 'NO_RECORD_FOUND':
              systemStatus = 'pending'
              break;
            case 'PENDING':
              systemStatus = 'pending'
              break;
          }
          resolve({
            status: systemStatus,
            txnDetails
          });
        });
      });
      post_req.write(post_data);
      post_req.end();
    });
  });
}


async function test() {
  const donationsRef = await db.collection('donations').where('payment.mode', '==', 'paytm').where('payment.status', '==', 'pending').get();
  const subRef = await db.collection('subscriptions').where('payment.mode', '==', 'paytm').where('payment.status', '==', 'pending').get();
  const docs = [];
  donationsRef.forEach(doc => {
    if (doc.id) {
      docs.push({
        id: doc.id,
        type: 'donations'
      })
    }
  })
  subRef.forEach(doc => {
    if (doc.id) {
      docs.push({
        id: doc.id,
        type: 'subscriptions'
      })
    }
  });
  console.log('length', docs.length);
  if (docs.length) {
    for (const doc of docs) {
      console.log('id', doc.id);
      const {
        status,
        txnDetails
      } = await getPaytmPaymentStatus(doc);
      console.log('status', status);
      await db.collection(doc.type).doc(doc.id).update({
        'payment.status': status,
        'payment.details': txnDetails,
      });
    }
  }
}

// test()

// getPaytmPaymentStatus()