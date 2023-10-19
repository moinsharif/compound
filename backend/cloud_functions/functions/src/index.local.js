const functions = require("firebase-functions");
const axios = require('axios');
const admin = require("firebase-admin");
const moment = require("moment");
const config = require("./cloud.config");
const fcmService = require("./index.fcm");
const reportsService = require("./index.reports");
const watchlistReportsService = require("./index.reports.watchlist");
const mailer = require("./index.mailer");
const time = require("timestamp-date");
const timestamp = new time.TimestampDate();

const serviceAccount = require("../../../serviceAccountKey_QA.json");
admin.initializeApp({
credential: admin.credential.cert(serviceAccount),
storageBucket: "trash-app-a3696.appspot.com",
});

const bucket = admin.storage().bucket();
const db = admin.firestore();
reportsService.sendEmailViolationsReports(bucket, db, {"violationsIds":[ "1655996771653", "1655997883034"]});

