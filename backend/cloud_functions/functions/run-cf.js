const serviceAccount = require('./serviceAccount.json');
const profile = require('./index.profiles');
const purchases = require('./index.purchases');

const admin = require('firebase-admin');

var data = {
    "id" : "0oKqxpgicSSQaiNzq3xUAcaOYp93",
    "parentId" : "7n3dTwCVe5ci9l8kvH5KVFUVH4J2",
    "feet" : "4"
}

start = async () => {
    var app = await admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
    const db = admin.firestore();
    //await profile.updateProfile(db, data);
    var result = await purchases.purchaseStatus(admin, db, "0oKqxpgicSSQaiNzq3xUAcaOYp93");
    console.log(JSON.stringify(result, undefined, 2));
}

start();

