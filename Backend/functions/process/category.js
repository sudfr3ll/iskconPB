const functions = require("firebase-functions");
const { db } = require("./admin");

exports.onWriteCatgeoryLevel_2 = functions.firestore.document("Categories-L2/{docId}").onWrite(async (change, context) => {
    const after = change.after.data() || {categoryId_L1: ''};
    const before = change.before.data() || {categoryId_L1: ''};
    if(after.categoryId_L1 !== before.categoryId_L1) {
        const categoryId_L1 = after.categoryId_L1 || before.categoryId_L1;
        console.log('categoryId_L1', categoryId_L1);
        const ref = db.collection("Categories-L2").where("categoryId_L1", "==", categoryId_L1)
        ref.get().then(async docs => {
            await db.collection("Categories-L1").doc(categoryId_L1).update({
                isSubCategory: docs.size ? true : false,
            });
        });
    }
});

exports.onWriteCatgeoryLevel_3 = functions.firestore.document("Categories-L3/{docId}").onWrite(async (change, context) => {
    const after = change.after.data() || {categoryId_L2: ''};
    const before = change.before.data() || {categoryId_L2: ''};
    if(after.categoryId_L2 !== before.categoryId_L2) {
        const categoryId_L2 = after.categoryId_L2 || before.categoryId_L2;
        console.log('categoryId_L2', categoryId_L2);
        const ref = db.collection("Categories-L3").where("categoryId_L2", "==", categoryId_L2)
        ref.get().then(async docs => {
            await db.collection("Categories-L2").doc(categoryId_L2).update({
                isSubCategory: docs.size ? true : false,
            });
        });
    }
});