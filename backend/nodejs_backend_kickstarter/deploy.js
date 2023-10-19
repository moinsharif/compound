// Imports
const firestoreService = require('firestore-export-import');
const deployVariables = require("./deploy-variables.ts");
const serviceAccount = require('../serviceAccount.json');
const admin = require('firebase-admin');
const firebase = require("firebase-tools");
firebase.use(serviceAccount.project_id, {
  add: false,
});

var fs = require('fs');


var projectName = "client";
var firestoreAppName = "https://"+serviceAccount.project_id+".firebaseio.com"; 


// JSON To Firestore
const migrateProject = async () => {
  try {
    console.log('---------------------------------------------------------------------------');
    console.log('-------------------Initializing Firebase Project---------------------------');
    console.log('---------------------------------------------------------------------------');
    await firestoreService.initializeApp(serviceAccount, firestoreAppName);
 
    console.log('Firebase Logged in');
    console.log('Config load to firestore');
    await firestoreService.restore('./_tables_base.json');

    /*await firestoreService.restore('./_tables_parks.json',{
      dates: ["dates.from", "dates.to"],
      geos: ['location']
    });*/

    //await firestoreService.restore('./_tables_parks_demo.json');
    console.log('Config apply variable deploy');
    //await deployVariables.deployEnviromentVariables('../config_cloud_'+ projectName +'.json', serviceAccount.project_id); TODO fix environment vars
    console.log('Config success!');
  }
  catch (error) {
    console.log(error);
  }
};

migrateProject();