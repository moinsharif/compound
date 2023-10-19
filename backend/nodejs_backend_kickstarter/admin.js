// Imports
const firestoreService = require('firestore-export-import');
const serviceAccount = require('../serviceAccount.json');
const admin = require('firebase-admin');
const firebase = require("firebase-tools");
firebase.use(serviceAccount.project_id, {
  add: false,
});

var fs = require('fs');
var readline = require('readline');
const { createCipher } = require('crypto');
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

var projectName = "client";
var firestoreAppName = "https://" + serviceAccount.project_id + ".firebaseio.com";

const db = admin.firestore();


const NodeGeocoder = require('node-geocoder');

const options = {
  provider: 'google',
  apiKey: 'AIzaSyBF7NOLdby5kzGKpfKud6RW2_OZ4fedSEI'
};

const geocoder = NodeGeocoder(options);

const path = "./migration/"

get_data = (filename) => {
  return new Promise(function (resolve, reject) {

    var data = [];
    var rd = readline.createInterface({
      input: fs.createReadStream(path + filename),
      output: process.stdout,
      console: false
    });

    rd.on('line', function (line, lineCount, byteCount) {
      data.push(line);
    })
      .on('close', function () {
        resolve(data);
      });
  });

};



const checkusers = async () =>{
  var list = await admin.auth().listUsers();
  console.log("USERS" + list.users.length);
}

const clearallusers = async () =>{
  var list = await admin.auth().listUsers();
  for(i = 0; i < list.users.length; i++){
    var user = list.users[i]
    await deleteuser(user);
  }
}

const deleteuser = async(user) => {
  await admin.auth().deleteUser(user.uid);
  await db.collection('roles').doc(user.uid).delete();
  await db.collection('users').doc(user.uid).delete();
} 

const createusers = async () => {

  await firestoreService.initializeApp(serviceAccount, firestoreAppName);

  var error = 0;
  var success = 0;

  var addedUsers = {}
  var data = await get_data("users_admin.csv");

  for (var i = 0; i < data.length; i++) {
    var line = data[i];
    if (await processUsers(addedUsers, line, i + 1)) {
      success++;
    } else {
      error++;
    }
  }

  console.log("Status: " + success + "/" + data.length + " Error:" + error);
  console.log("done");
}

const processUsers = async (addedUsers, line, idx) => {

  try {
    if (addedUsers[line] == null)
      addedUsers[line] = true;
    else {
      console.log("Users DUPLICATED: " + address);
      return false;
    }

    var lineSplit = line.split(",")
    var firebaseUser = {
      email: lineSplit[2].trim(),
      emailVerified: true,
      password: "Css!2021#",
      displayName: lineSplit[0].trim(),
      disabled: false,
    }

    var nameParts =  firebaseUser.displayName.split(" ");
    var firstName = nameParts[0];
    var lastName = nameParts[1];

    var userRecord = await admin.auth().createUser(firebaseUser)
    var user = {
      active: true,
      changePassword: true,
      createdAt: new Date(),
      email: firebaseUser.email,
      fcmToken: null,
      firstName: firstName,
      id: userRecord.uid,
      img: null,
      isEmployee: false,
      lastName: lastName,
      phoneNumber: lineSplit[3].trim(),
      temporalPassword: null,
      userName: lastName.toLowerCase()[0] + firstName.toLowerCase()
    }
    var role = {
      admin: true,
      super_admin: false,
      user_tier_1: false,
      user_tier_2: false
    }

    await db.collection('users').doc(user.id).set(user, { merge: true });
    await db.collection('roles').doc(user.id).set(role, { merge: true });
    console.log("User created", userRecord.toJSON());
    return true;
  } catch (e) {
    console.log("User ERROR: " + line + ", row:" + idx);
    console.log(e);
    return false;
  }

}

const inactivateproperties = async ()=> {
    var all = await db.collection('properties').get();
    for(var i = 0; i < all.docs.length; i ++){
        await await db.collection('properties').doc(all.docs[i].id).update({active:false});
    }
}

const createproperties = async () => {

  await firestoreService.initializeApp(serviceAccount, firestoreAppName);

  var error = 0;
  var success = 0;

  var addedUsers = {}
  var data = await get_data("properties.csv");

  for (var i = 0; i < data.length; i++) {
    var line = data[i];
    if (await processProperties(addedUsers, line, i + 1)) {
      success++;
    } else {
      error++;
    }
  }

  console.log("Status: " + success + "/" + data.length + " Error:" + error);
  console.log("done");
}

processProperties = async (addedUsers, line, idx) => {

  var lineSplit = line.split(",\"")
  var address = lineSplit[1].trim().replace("\"", "").replace("\"", "")
  if (addedUsers[line] == null)
    addedUsers[line] = true;
  else {
    console.log("Address DUPLICATED: " + address);
    return false;
  }

  try {
    var marketId = "G8CQIZFVPRRf4Jl7M0cU"
    var marketName = "Default"

    var ref = db.collection('properties').doc()
    const geocodedAddress = await geocoder.geocode(address);
    if (geocodedAddress.length < 1) {
      console.log("Address NOT FOUND: " + address);
      return false;
    }

    if (geocodedAddress.length > 1) {
      console.log("Address MULTIPLE FOUND: " + address);
      console.log("Geocoded: " + JSON.stringify(geocodedAddress, undefined, 2));
      return false;
    }

    var geoAddress = geocodedAddress[0]

    var property = {
      id: ref.id,
      active: true,
      address: address,
      createdAt: new Date(),
      emails: [],
      dateVisited: null,
      flagged: false,
      lat: geoAddress.latitude,
      lng: geoAddress.longitude,
      marketId: marketId,
      marketName: marketName,
      phone: null,
      propertyName: lineSplit[0].trim(),
      specialInstructions: null,
      totalViolations: 0,
      units: [],
      updatedAt: null
    }

    //console.log(property);

    await ref.set(property, { merge: true });
    console.log("Address processed " + address);
    return true;
  } catch (e) {
    console.log("Address ERROR: " + line + ", row:" + idx);
    console.log(e);
    return false;
  }

}


//clearallusers();
//createproperties();
createusers();
//checkusers();
//inactivateproperties();

