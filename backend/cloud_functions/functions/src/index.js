const functions = require("firebase-functions");
const axios = require('axios');
const admin = require("firebase-admin");
const moment = require("moment");
const fcmService = require("./index.fcm");
const reportsService = require("./index.reports");
const watchlistReportsService = require("./index.reports.watchlist");
const mailer = require("./index.mailer");
const time = require("timestamp-date");
const timestamp = new time.TimestampDate();

admin.initializeApp();

const bucket = admin.storage().bucket();
const db = admin.firestore();
const { google } = require("googleapis");
const OAuth2 = google.auth.OAuth2;

const config = require("./cloud.config").config;
const crypto = require("crypto");
const { RFC_2822 } = require("moment");
const algorithm = "des-ecb";
const secretKey = Buffer.from("trash_app_2021_secret_key_encode", "utf8");
const iv = Buffer.from("trash%?app2021#?", "utf8");
const leaseTime = 15 * 1000; // 60s

const encodePassword = async (password) => {
  return new Promise((res, rej) => {
    const cipher = crypto.createCipheriv(algorithm, Buffer.from(secretKey), iv);
    let encrypted = cipher.update(password);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    res(encrypted.toString("hex"));
  });
};

const decodePassword = (password) => {
  const decipher = crypto.createDecipheriv(algorithm, secretKey, iv);
  let decrypted = decipher.update(password, "hex", "utf8");
  decrypted += decipher.final("utf8");
  return decrypted;
};


// eslint-disable-next-line require-jsdoc
async function sendMail(email, userName, password) {
  console.log("Sending mail to " + email);
  const mailOptions = {
    from: mailer.config.origin,
    to: email,
    subject: "TrashApp - Welcome!!",
    html: `<p style="font-size: 16px;">Hello ${userName}</p>
                <br />
                <p style="font-size: 16px;">´username: ${email}´</p>
                <p style="font-size: 16px;">´password: ${password}´</p>
            `,
  };

  return mailer.transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log("Error sending mail " + error);
      return {
        result: { status: 500, error: error },
      };
    }
    return { result: { status: 200, success: "sent" } };
  });
}

exports.getDataFromUrl = functions.https.onCall(async (data, context) => {
  const url = data.url;
  try {
    const info = await axios.get(url);
    return info.data;
  } catch (error) {
    return (error);
  }
});


exports.triggerChatMessage = functions.firestore
  .document("messages/{group}/messages_history/{id}")
  .onCreate(async (snap, context) => {
    const created = snap.data();
    const idTo = created.idTo;
    const snapshot = await db.collection("users")
      .doc(idTo).get();
    if (snapshot.exists) {
      const recipient = snapshot.data();
      if (recipient.fcmToken != null && recipient.fcmToken != "") {
        const room = {
          "owner": created.idFrom,
          "id": created.idTo,
          "nickname": recipient.firstName + " " + recipient.lastName,
          "photoUrl": recipient.img,
        };
        fcmService.sendPushNotification(admin, recipient.firstName + " " + recipient.lastName + ":", created.content, recipient.fcmToken, room);
      }
    }
  });

exports.sendViolationsReport = functions.https.onCall((data) => {
  return reportsService.sendEmailViolationsReports(bucket, db, data);
});

exports.sendWatchlistReport = functions.https.onCall((data) => {
  return watchlistReportsService.sendEmailWatchlistReports(bucket, db, data);
});

exports.changePassword = functions.https.onCall(async (data) => {
  const { uid, password, role } = data;
  let validRole = false;

  for (let i = 0; i < config.admin_roles.length; i++) {
    console.log(config.admin_roles[i]);
    console.log(role);
    if (config.admin_roles[i] == role) {
      validRole = true;
    }
  }

  if (!validRole) {
    return {
      status: 500,
      error: "you do not have sufficient permissions for this action.",
    };
  }

  try {
    const snapshot = await admin.auth().updateUser(uid, { password: password });
    if (!snapshot) {
      return { status: 500, error: "invalid_code" };
    } else {
      return { status: 200, error: "success" };
    }
  } catch (e) {
    return { status: 500, error: e.message };
  }
});

/*
DEBUG PURPOSE
exports.sendViolationsReport2 = functions.https.onRequest((req, res) => {
  return reports.sendEmailViolationsReports(bucket, db, req.body);
});*/

exports.registerFromAdmin = functions.https.onCall(async (data, context) => {
  const { password, role, roleCreated, userName,
    firstName, lastName, phoneNumber } = data;

  let validRole = false;
  for (let i = 0; i < config.admin_roles.length; i++) {
    if (config.admin_roles[i] == role) {
      validRole = true;
    }
  }

  if (!validRole) {
    return {
      status: 500,
      error: "you do not have sufficient permissions for this action.",
    };
  }

  if (roleCreated === config.admin && role !== config.root) {
    return {
      status: 500,
      error: "you do not have sufficient permissions for this action.",
    };
  }
  const username = userName.concat("@hd.com");
  return admin
    .auth()
    .createUser({
      email: username,
      password: password,
    })
    .then(async (userRecord) => {
      try {
        const batch = db.batch();
        batch.set(db.doc("users/" + userRecord.uid), {
          "email": username,
          "userName": userName,
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "temporalPassword": password,
          "changePassword": true,
          "createdAt": admin.firestore.FieldValue.serverTimestamp(),
          "active": true,
          "isEmployee": roleCreated !== config.admin,
          "id": userRecord.uid,
        });
        batch.set(db.doc("employees/" + userRecord.uid), {
          "id": userRecord.uid,
          "legend": "Experienced Porter",
          "markers": [],
          "properties": [],
          "temporalProperties": [],
        });
        let roleData = {};
        if (roleCreated === config.admin) {
          roleData =
          {
            "admin": true,
            "super_admin": false,
            "user_tier_1": true,
            "user_tier_2": false,
          };
        } else {
          roleData =
          {
            "admin": false,
            "super_admin": false,
            "user_tier_1": true,
            "user_tier_2": false,
          };
        }
        batch.set(db.doc("roles/" + userRecord.uid), roleData);
        await batch.commit();
        return { status: 200, message: "success" };
      } catch (e) {
        return { status: 500, message: e.code };
      }
    })
    .catch((error) => {
      return {
        status: 500,
        error: error.code, message: error.message
      };
    });
});

exports.register = functions.https.onCall(async (data, context) => {
  const { email, password, code, role, userName,
    firstName, lastName, phoneNumber } = data;

  let validRole = false;
  for (let i = 0; i < config.public_roles.length; i++) {
    if (config.public_roles[i] == role) {
      validRole = true;
    }
  }

  if (!validRole) {
    return { result: { status: 500, error: "invalid_data" } };
  }

  if (role == "admin") {
    if (code == null || code == "") {
      return { result: { status: 500, error: "invalid_code" } };
    }

    try {
      const snapshot = await db.collection("users_invitations")
        .doc(email).get();
      if (!snapshot.exists) {
        return { result: { status: 500, error: "invalid_code" } };
      } else {
        if (snapshot.data()["accepted"] == true) {
          return { result: { status: 500, error: "accessed_code" } };
        }
        if (snapshot.data()["code"] != code) {
          return { result: { status: 500, error: "invalid_code" } };
        }
      }

      await db.doc("users_invitations/" + email)
        .update({ "registerAttempted": true, "code": code });
    } catch (e) {
      return { result: { status: 500, error: "invalid_code" } };
    }
  }

  return admin
    .auth()
    .createUser({
      email: email,
      password: password,
    })
    .then(async (userRecord) => {
      try {
        const batch = db.batch();
        batch.set(db.doc("users/" + userRecord.uid), {
          "email": email,
          "userName": userName,
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "temporalPassword": password,
          "changePassword": false,
          "createdAt": admin.firestore.FieldValue.serverTimestamp(),
          "active": true,
          "isEmployee": true,
          "id": userRecord.uid,
        });
        batch.set(db.doc("employees/" + userRecord.uid), {
          "id": userRecord.uid,
          "legend": "Experienced Porter",
          "markers": [],
          "properties": [],
          "temporalProperties": [],
        });
        const roleData = {};
        for (let i = 0; i < config.roles.length; i++) {
          roleData[config.roles[i]] = config.roles[i] == role;
        }

        if (role == "admin") {
          roleData["email"] = email;
          roleData["code"] = code;
        }
        batch.set(db.doc("roles/" + userRecord.uid), roleData);
        await batch.commit();
        if (role == "admin") {
          await db.doc("users_invitations/" + email).set({
            "accepted": true,
            "code": code,
            "status": "Accepted",
          }, { merge: true });
        } else {
          sendMail(email, userName, password);
        }
      } catch (e) {
        return { result: { status: 500, error: e.code } };
      }

      return { result: { status: 200, success: userRecord.uid } };
    })
    .catch((error) => {
      return {
        result: {
          status: 500,
          error: error.code, message: error.message
        }
      };
    });
});

exports.triggerViolation = functions.firestore
  .document("violations/{id}")
  .onCreate(async (snap, context) => {
    const created = snap.data();
    const snapshot = await db.collection("properties")
      .doc(created.propertyId).get();
    if (snapshot.exists) {
      const property = snapshot.data();
      property["totalViolations"] += 1;
      property["dateVisited"] = admin.firestore.FieldValue.serverTimestamp(),
        await snapshot.ref.set(
          {
            totalViolations: property["totalViolations"],
            dateVisited: property["dateVisited"],
          },
          { merge: true }
        );
    }
  });



exports.getTimeSheets = functions.https.onCall(async (data, context) => {
  try {
    let listTimesheets = [];
    let listProperties = [];
    let customTimesheets = [];
    const timesheets = await db.collection("timesheet")
      .get();
    const properties = await db.collection("properties")
      .where("active", "==", true).get();
    listTimesheets = timesheets.docs.map((doc) => {
      const data = doc.data();
      return {
        ...data, "dateCheckIn":
          moment(data.dateCheckIn.toDate(), "YYYY-MM-DD HH:mm Z")
            .utcOffset(-6, false).format().replace("-05:00", ""),
        "dateCheckOut": data.dateCheckOut !== null ?
          moment(data.dateCheckOut.toDate(), "YYYY-MM-DD HH:mm Z")
            .utcOffset(-6, false).format().replace("-05:00", "") : null,
        "dateCheckInByAdmin": data.checkInByAdmin === true ?
          moment(data.dateCheckInByAdmin.toDate(), "YYYY-MM-DD HH:mm Z")
            .utcOffset(-6, false).format().replace("-05:00", "") : null
      };
    });
    listProperties = properties.docs.map((doc) => doc.data());
    // list days to evaluate only dates without porters
    const daysToService = addDays();
    // console.log(day.date);
    listProperties.forEach((prop) => {
      daysToService.forEach((day) => {
        // date to creation of this property
        const dateCreateProp = moment(prop.configProperty
          .createdAt.toDate()).utcOffset(-6, false);
        let endDate;
        if (prop.configProperty
          .endDate != null) {
          endDate = moment(prop.configProperty
            .endDate.toDate()).utcOffset(-6, false);
        }
        const dateToCreationProperty = new Date(
          dateCreateProp.year(),
          dateCreateProp.month(),
          dateCreateProp.date());
        // valuate if in this day exist a checkIn in this property
        // and if is in the rage of creation and finish the contract
        // console.log(`${new Date(day.date) >= dateToCreationProperty} - ${new Date(day.date)} -- ${dateToCreationProperty} ${prop.propertyName}`);
        const evalDay = prop.configProperty.daysSelected
          .find((dayS) => {
            // console.log(`${dayS.id} - ${day.id}`);
            // console.log((dayS.id === day.id && new Date(day.date) >=
            //     dateToCreationProperty));
            return (dayS.id === day.id && new Date(day.date) >=
              dateToCreationProperty &&
              prop.configProperty.end === false ||
              (prop.configProperty.end === true &&
                new Date(day.date) <=
                new Date(endDate.year(),
                  endDate.month(),
                  endDate.date())));
          });
        if (evalDay !== undefined) {
          const timesheet = listTimesheets.filter((pay) => {
            const dateTimes = new Date(
              moment(pay.dateCheckIn)
                .utcOffset(-6, false).year(),
              moment(pay.dateCheckIn)
                .utcOffset(-6, false).month(),
              moment(pay.dateCheckIn)
                .utcOffset(-6, false).date());
            const dayToday = new Date(
              new Date(day.date).getFullYear(),
              new Date(day.date).getMonth(),
              new Date(day.date).getDate());
            // console.log(`${dateTimes} - ${dayToday} ${pay.propertyId} - ${prop.id}`);
            return (pay.propertyId === prop.id &&
              moment(dateTimes, "YYYY-MM-DD").isSame(dayToday, "YYYY-MM-DD")
            );
          });
          // if (timesheet.length > 0)console.log("timesheet", timesheet);
          if (timesheet !== null && timesheet.length > 0) {
            const listPorters = prop.configProperty.porters.filter((e) =>
            (e.temporary === null || e.temporary === false ||
              (e.temporary === true && new Date(
                moment(e.temporary_date.toDate())
                  .utcOffset(-6, false).year(),
                moment(e.temporary_date.toDate())
                  .utcOffset(-6, false).month(),
                moment(e.temporary_date.toDate())
                  .utcOffset(-6, false).date()) >= new Date(
                    new Date(day.date).getFullYear(),
                    new Date(day.date).getMonth(),
                    new Date(day.date).getDate())
              )));
            if (timesheet.length < listPorters.length) {
              listPorters.forEach((arr) => {
                const port = timesheet.find((e) => e.employeId === arr.id);
                if (port === undefined) {
                  const today = moment(new Date()).utcOffset(-6, false);
                  const dayToServ = new Date(
                    new Date(day.date).getFullYear(),
                    new Date(day.date).getMonth(),
                    new Date(day.date).getDate(),
                    parseInt(prop
                      .configProperty.startTime.slice(0, 2)),
                    parseInt(prop
                      .configProperty.startTime.slice(3, 5)));
                  const passToDate = today.isAfter(moment(dayToServ));
                  const auxTimesheet = {
                    checkInByAdmin: false,
                    checkInId: null,
                    dateCheckIn: dayToServ
                      .toISOString(),
                    dateCheckInByAdmin: null,
                    dateCheckOut: null,
                    employeId: arr.id,
                    employeeName: arr.lastName + ", " + arr.firstName,
                    id: null,
                    propertyId: prop.id,
                    propertyName: prop.propertyName,
                    status: passToDate ? "Not started" : "Normal",
                  };
                  customTimesheets = [...customTimesheets, auxTimesheet];
                }
              });
            }
            customTimesheets = [...customTimesheets, ...timesheet];
          } else {
            const listPorters = prop.configProperty.porters.filter((e) =>
            (e.temporary === null || e.temporary === false ||
              (e.temporary === true && new Date(
                new Date(e.temporary_date).getFullYear(),
                new Date(e.temporary_date).getMonth(),
                new Date(e.temporary_date).getDate()) <= new Date(
                  new Date(day.date).getFullYear(),
                  new Date(day.date).getMonth(),
                  new Date(day.date).getDate())
              )));
            listPorters.forEach((arr) => {
              const today = moment(new Date()).utcOffset(-6, false);
              const dayToServ = new Date(
                new Date(day.date).getFullYear(),
                new Date(day.date).getMonth(),
                new Date(day.date).getDate(),
                parseInt(prop
                  .configProperty.startTime.slice(0, 2)),
                parseInt(prop
                  .configProperty.startTime.slice(3, 5)));
              const passToDate = today.isAfter(moment(dayToServ));
              const auxTimesheet = {
                checkInByAdmin: false,
                checkInId: null,
                dateCheckIn: dayToServ.toISOString(),
                dateCheckInByAdmin: null,
                dateCheckOut: null,
                employeId: arr.id,
                employeeName: arr.lastName + ", " + arr.firstName,
                id: null,
                propertyId: prop.id,
                propertyName: prop.propertyName,
                status: passToDate ? "Not started" : "Normal",
              };
              customTimesheets = [...customTimesheets, auxTimesheet];
            });
          }
        }
      });
    });
    return customTimesheets.sort(
      (a, b) => new Date(b.dateCheckIn) - new Date(a.dateCheckIn));
  } catch (_) {
    return "error";
  }
});

const addDays = () => {
  let daysToService = [];
  const today = moment(new Date()).utcOffset(-6, false);
  let dateToCompare = new Date(
    today.year(),
    today.month(),
    today.date() - 10);
  let currentDay = dateToCompare.getDay();
  const dateToNow = new Date(
    today.year(),
    today.month(),
    today.date());
  while (dateToCompare <= dateToNow) {
    if (currentDay > 6) {
      currentDay = 0;
      daysToService = [
        ...daysToService,
        {
          id: currentDay,
          date: dateToCompare.toUTCString()
        },
      ];
      currentDay += 1;
    } else {
      daysToService = [
        ...daysToService,
        {
          id: currentDay,
          date: dateToCompare.toUTCString()
        },
      ];
      currentDay += 1;
    }
    dateToCompare = new Date(dateToCompare
      .setDate(dateToCompare.getDate() + 1));
  }
  return daysToService;
};