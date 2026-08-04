const admin = require("firebase-admin");
const serviceAccount = require("../service-account.json");
admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: "https://bwi-iskon-dev.firebaseio.com",
	storageBucket: "bwi-iskon-dev.appspot.com"
})
const db = admin.firestore();
const bucket = admin.storage().bucket();
const projectId = serviceAccount.project_id;
const timeZone = 'Asia/Kolkata';

const typesenseCred = {
  // apiKey: "eQqII9bxwm3rFqn00HAsibrnHfYpTczh", //! Alpha Cred
  // searchOnlyKey: "OFS4RMW1vOAzJrwh1qM8i8If5qed7x4B",
  // host: "tkbs34xd5wfh6ucgp-1.a1.typesense.net",

  // apiKey: "IBoWB1DBIRDlQ1pGIsGovmf6Dmqlnr7q", //! Sandeep Cred
  // searchOnlyKey: "mo4lzSWzFR529jo3qMhgK6R9rDK268Ro",
  // host: "bivxrg8jf0ez4hdsp-1.a1.typesense.net",

  apiKey: "t6PlP3YPD3C8neVisETp1b9S30nVhDqt", //! Iskon Cred
  searchOnlyKey: "Rep69hUFjEeBQLJJIUvOA5LXHp8smTRL",
  host: "dtg03o2bkxian81lp-1.a1.typesense.net",

  port: 443,
  protocol: "https"
}

module.exports = {
  admin,
  db,
  bucket,
  projectId,
  timeZone,
  typesenseCred,
}