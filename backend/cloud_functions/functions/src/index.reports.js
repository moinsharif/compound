// const pdf = require("pdf-creator-node");
const Printer = require("pdfmake");

const ExifReader = require('exifreader');
const gm = require('gm').subClass({ imageMagick: true });

const cloudConfig = require("./cloud.config").config;
const fs = require("fs");
const moment = require("moment");
const config = require("./index.config");
const mailer = require("./index.mailer");
const dateHelper = require("./date.helper");
const fonts = require("pdfmake/build/vfs_fonts.js");
const base64converter = require("node-base64-image");
const request = require("request");
const fontDescriptors = {
  Roboto: {
    normal: Buffer.from(fonts.pdfMake.vfs["Roboto-Regular.ttf"], "base64"),
    bold: Buffer.from(fonts.pdfMake.vfs["Roboto-Medium.ttf"], "base64"),
    italics: Buffer.from(fonts.pdfMake.vfs["Roboto-Italic.ttf"], "base64"),
    bolditalics: Buffer.from(fonts.pdfMake.vfs["Roboto-Italic.ttf"], "base64"),
  },
};

exports.sendEmailViolationsReports = async (bucket, db, data) => {
  return new Promise(async (resolve, reject) => {
    try {
      const documents = await generatePropertyReports(db, data);
      for (let i = 0; i < documents.length; i++) {

        if (cloudConfig.localMode) {
          await saveReportFileSystem(bucket, documents[i]);
        } else {
          const reportUrl = await saveReportFile(bucket, documents[i]);
          console.log(reportUrl);
          var emails = cloudConfig.debugReports ? [mailer.config.debugMail] : documents[i].emails;
          for (let j = 0; j < emails.length; j++) {
            await sendMail(reportUrl, documents[i], emails[j]);
          }
        }
      }

      resolve({ result: { status: 200 } });
    } catch (e) {
      reject({ result: { status: 500, error: e } });
    }
  });
};

async function saveReportFileSystem(bucket, document) {
  return new Promise(async (resolve, reject) => {
    fs.writeFile("C:\\Workspace\\Proyectos-US\\C7\\C7 - TrashApp\\pdfOUT\\test.pdf", document["reportBuffer"], "binary", function (err) {
      if (err) {
        console.log(err);
        resolve();
      } else {
        console.log("The file was saved!");
        resolve();
      }
    });
  });
}

async function saveReportFile(bucket, document) {
  return new Promise(async (resolve, reject) => {
    const fileRef = bucket.file(
      document["path"],
      {
        metadata: { contentType: "application/pdf" },
      }
    );
    fileRef.save(document["reportBuffer"]);
    return fileRef.getSignedUrl({
      action: "read",
      expires: "03-09-2491",
    }).then((signedUrls) => {
      resolve(signedUrls[0]);
    });
  });
}


async function sendMail(reportUrl, document, email) {
  console.log("Sending mail to " + email);
  const time = document.dateToSend;
  console.log("Time to " + time);
  const mailOptions = {
    from: mailer.config.origin,
    to: email,
    subject: "Hello Doorstep Report - " + time,
    attachments: [
      {
        filename: document["name"],
        path: reportUrl,
      },
    ],
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


async function generatePropertyReports(db, data) {
  try {
    const ids = data["violationsIds"];
    console.log("Reports: Requesting report for IDS (" + ids + ")");
    const reports = {};
    for (let i = 0; i < ids.length; i++) {
      const violationDb = await db.collection("violations").doc(ids[i]).get();
      if (violationDb.exists) {
        const violationData = violationDb.data();
        const propertyId = violationData["propertyId"];
        const propertyDb = await db.collection("properties").doc(propertyId).get();
        if (propertyDb.exists) {
          const propertyData = propertyDb.data();
          if (propertyData["emails"] == null || propertyData["emails"].length < 1) {
            console.log("Reports: property without mail (" + ids[i] + ")");
            continue;
          }
          const date = dateHelper.convertToDateLocal(violationData["createdAt"].toDate());
          if (reports[propertyId] == null) {
            reports[propertyId] = {
              "propertyName": propertyData["propertyName"],
              "propertyAddress": propertyData["address"],
              "emails": propertyData["emails"],
              headers: [],
              violations: [],
              watchlist: []
            };
          }

          var report = reports[propertyId];
          const checkInId = violationData["checkInId"];
          if (report.headers.find((value) => value['checkInId'] == checkInId) == null) {
            const checkIn = await db.collection("checkIns").doc(checkInId).get();
            if (checkIn.exists) {
              var detail = checkIn.data();
              report.headers.push({
                checkInId: violationData["checkInId"],
                headerDate: dateHelper.formatDate(detail, "dateCheckIn", "MM-DD-YYYY"),
                propertyName: propertyData.propertyName,
                propertyAddress: propertyData.address,
                imgCheckIn: await convertImageTo64Bits(detail.imageCheckIn),
                imgCheckOut: detail?.imageCheckOut != null ? await convertImageTo64Bits(detail?.imageCheckOut) : "",
                dateCheckIn: detail?.dateCheckIn,
                dateCheckInTz: detail?.dateCheckInTz
              })
            } else {
              console.log("Reports: Violation orphaned CheckIn ViolationId (" + ids[i] + ") CheckInId (" + checkInId + ")");
            }
          }

          var notContainViolation = Array.isArray(report["violations"]) &&
            report["violations"]
              .findIndex((e) => e.id === violationData["id"]) === -1;
          if (notContainViolation) {
            report["violations"].push(violationData);
          }

          if (report["watchlist"].length === 0) {
            const watchList = await getWatchList(date, db, propertyId);
            if (watchList.length > 0) {
              report["watchlist"] = watchList;
            }
          }
        } else {
          console.log("Reports: violation without property assigned (" + ids[i] + ")");
        }
      }
    }

    const generatedReports = [];
    for (const attr in reports) {
      const reportData = reports[attr];
      if (reportData.headers.length > 0){

        if(reportData.headers.length > 1){
          var recent = reportData.headers.sort((a,b) => { return a['checkInId'] - b['checkInId']});
          reportData.headers = [recent[0]]
        }

        generatedReports.push(await generatePdf(reportData));
      }
    }
    return generatedReports;
  } catch (e) {
    return [];
  }
}

async function convertImageTo64Bits(src) {
  try {
    return await getBase64ImageFromURL(src)
      .then((imageBase64) => {
        return "data:image/jpeg;base64," + imageBase64;
      })
      .catch((_) => {
        return "data:image/jpeg;base64," + config.noImageAvailable;
      });
  } catch (e) {
    console.log("Error generating base64 image " + src);
    console.log(e);
    return "data:image/jpeg;base64," + config.noImageAvailable;
  }
}

async function getWatchList(date, db, propertyId) {
  return db.collection("watchlist")
    .where("propertyId", "==", propertyId)
    .where("date", ">=",
      dateHelper.convertToDateServerFrom(date))
    .where("date", "<=",
      dateHelper.convertToDateServerTo(date))
    .get()
    .catch((error) => {
      console.log(error);
    })
    .then((snapshot) => {
      if (snapshot.empty) {
        return [];
      }
      return snapshot.docs.map((document) => document.data());
    });
}

const violationGuidelinesDescription = "All units compliant with Service Guidelines";

const generatePdf = (reportData) => {
  return new Promise(async (resolve, reject) => {
    const printer = new Printer(fontDescriptors);
    const invoices = [];
    const chunks = [];

    var hasAllComplianceType = false;
    var hasAtLeastOnceObs = false;
    for (let i = 0; i < reportData["violations"].length; i++) {
      if (reportData["violations"][i]["violationType"] != null &&
        reportData["violations"][i]["violationType"].indexOf(violationGuidelinesDescription) >= 0) {
        hasAllComplianceType = true;
      } else {
        hasAtLeastOnceObs = true;
      }
    }

    var excludeAllCompliance = hasAllComplianceType && hasAtLeastOnceObs;

    for (let i = 0; i < reportData["violations"].length; i++) {

      if (excludeAllCompliance) {
        if (reportData["violations"][i]["violationType"] != null &&
          reportData["violations"][i]["violationType"].indexOf(violationGuidelinesDescription) >= 0) {
          continue;
        }
      }

      const invoice = {};
      invoice.images0 = config.transparentImage;
      invoice.images1 = config.transparentImage;
      invoice.images2 = config.transparentImage;
      for (let j = 0; j < reportData["violations"][i]["images"].length; j++) {
        const imageUri = reportData["violations"][i]["images"][j];
        try {
          invoice["images" + j] = await convertImageTo64Bits(imageUri);
        } catch (e) {
          console.log("Error generating base64 image " + imageUri);
          console.log(e);
        }
      }
      const unit = reportData["violations"][i]["unit"] ? reportData["violations"][i]["unit"] : "";
      const desc = reportData["violations"][i]["description"] ? reportData["violations"][i]["description"] : "";
      invoice.propertyName = reportData["propertyName"];
      invoice.propertyAddress = reportData["propertyAddress"];
      invoice.serviceDate = dateHelper.formatDate(reportData["violations"][i], "createdAt", "dddd, MMMM DD, YYYY");
      invoice.serviceTime = dateHelper.formatDateWithTime(reportData["violations"][i], "createdAt", "MM-DD-YYYY");
      invoice.unitNumber = unit;
      invoice.typeOfViolation = `${reportData["violations"][i]["violationType"].join(", ")}.`;
      invoice.comments = desc;
      invoices.push(invoice);
    }

    var watchlist = []
    await Promise.all(
      reportData["watchlist"].map(async (e, index) => {
        try {
          await convertImageTo64Bits(e.image).then((r) => {
            watchlist.push({
              propertyName: e.propertyName,
              header: index === 0,
              serviceDate: e['completionDate'] != null?  dateHelper.formatDate(e, "completionDate", "dddd, MMMM DD, YYYY", true) : dateHelper.formatDate(e, "date", "dddd, MMMM DD, YYYY", true),
              serviceTime:  e['completionDate'] != null? dateHelper.formatDateWithTime(e, "completionDate", "MM-DD-YYYY", true) :  dateHelper.formatDateWithTime(e, "date", "MM-DD-YYYY", true),
              unit: e.name ? e.name : "",
              image: r,
            });
          });
        } catch (e) {
          console.log(e);
        }
      })
    );
    watchlist = watchlist.sort((a, b) => b.header - a.header);

    const headers = reportData["headers"];
    var mainHeader = headers[0];
    const time = mainHeader.headerDate;
    const fileName = reportData["propertyName"] + "_" + time + ".pdf";
    const content = [];

    content.push({
      image: config.imgHeader,
      width: 570,
      height: 340,
      style: { alignment: "center" },
      margin: [0, 10],
    },
      {
        text: "Daily Report " + mainHeader.headerDate,
        fontSize: 20,
        style: { alignment: "center" },
        margin: [5, 0],
      },
      {
        text: "Property Name: " + mainHeader.propertyName,
        fontSize: 20,
        style: { alignment: "center" },
        margin: [5, 0],
      },
      {
        text: mainHeader.propertyAddress,
        fontSize: 20,
        style: { alignment: "center" },
        margin: [5, 0],
      });
    headers.forEach((header, index) => {
      content.push(
        {
          columns: [
            {
              text: "Check-In Image " + (headers.length > 1 ? index + 1 : ""),
              style: { alignment: "center" },
            },
            {
              text: "Check-Out Image " + (headers.length > 1 ? index + 1 : ""),
              style: { alignment: "center" },
            },
          ],
          margin: [0, 10],
          columnGap: 5,
        },
        {
          columns: [
            {
              image: header.imgCheckIn !== "" ? header.imgCheckIn : "data:image/jpeg;base64," + config.noImageAvailable,
              width: 270,
              height: 250,

            },
            {
              image: header.imgCheckOut !== "" ? header.imgCheckOut : "data:image/jpeg;base64," + config.noImageAvailable,
              width: 270,
              height: 250,
            },
          ],
          columnGap: 5,
          pageBreak: "after",
        });
    });

    watchlist.forEach((watchList, indexList) => {
      const watch = [
        watchList.header ? {
          text: "Watchlist Information:",
          fontSize: 20,
          decoration: "underline",
          bold: true,
          margin: [0, 0, 0, 5],
        } : {},
        {
          columns: [
            {
              text: "Property Name:",
              fontSize: 15,
            },
            {
              text: watchList.propertyName,
              fontSize: 15,
            },
          ],
          margin: [0, 3],
          columnGap: 1,
        },
        {
          columns: [
            {
              text: "Service Date:",
              fontSize: 15,
            },
            {
              text: watchList.serviceDate,
              fontSize: 15,
            },
          ],
          margin: [0, 3],
          columnGap: 1,
        },
        {
          columns: [
            {
              text: "Time of observation:",
              fontSize: 15,
            },
            {
              text: watchList.serviceTime,
              fontSize: 15,
            },
          ],
          margin: [0, 3],
          columnGap: 1,
        },
        {
          columns: [
            {
              text: "Unit #:",
              fontSize: 15,
            },
            {
              text: watchList.unit,
              fontSize: 15,
            },
          ],
          margin: [0, 3],
          columnGap: 1,
        },
        {
          text: "Images:",
          fontSize: 20,
          decoration: "underline",
          bold: true,
          margin: [0, 0, 0, 10],
        },
        (indexList === 0 && watchlist.length === 1) ? {
          columns: [
            {
              image: watchList.image !== "" ? watchList.image : "data:image/jpeg;base64," + config.noImageAvailable,
              width: 230,
              height: 210,
            },
          ],
          margin: [0, 3],
          columnGap: 5,
          pageBreak: "after",
        } : (indexList % 2 !== 0 || (indexList + 1) === watchlist.length) ? {
          columns: [
            {
              image: watchList.image !== "" ? watchList.image : "data:image/jpeg;base64," + config.noImageAvailable,
              width: 230,
              height: 210,
            },
          ],
          margin: [0, 3],
          columnGap: 5,
          pageBreak: "after",
        } : {
          columns: [
            {
              image: watchList.image !== "" ? watchList.image : "data:image/jpeg;base64," + config.noImageAvailable,
              width: 230,
              height: 210,
            },
          ],
          margin: [0, 3],
          columnGap: 5,
        },
      ];
      content.push(...watch);
    });

    invoices.forEach((invoice, index) => {
      const report = [{
        text: "Observation Information:",
        fontSize: 20,
        decoration: "underline",
        bold: true,
        margin: [0, 0, 0, 10],
      },
      {
        columns: [
          {
            text: "Property Name:",
            fontSize: 15,
          },
          {
            text: invoice.propertyName,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        columns: [
          {
            text: "Service Date:",
            fontSize: 15,
          },
          {
            text: invoice.serviceDate,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        columns: [
          {
            text: "Unit #:",
            fontSize: 15,
          },
          {
            text: invoice.unitNumber,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        columns: [
          {
            text: "Time of observation:",
            fontSize: 15,
          },
          {
            text: invoice.serviceTime,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        columns: [
          {
            text: "Observation:",
            fontSize: 15,
          },
          {
            text: invoice.typeOfViolation,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        columns: [
          {
            text: "Description:",
            fontSize: 15,
          },
          {
            text: invoice.comments,
            fontSize: 15,
          },
        ],
        margin: [0, 3],
        columnGap: 1,
      },
      {
        text: "Images:",
        fontSize: 20,
        decoration: "underline",
        bold: true,
        margin: [0, 0, 0, 5],
      },
      {
        columns: [
          {
            image: invoice.images0 !== "" ? invoice.images0 : "data:image/jpeg;base64," + config.noImageAvailable,
            width: 270,
            height: 250,

          },
          {
            image: invoice.images1 !== "" ? invoice.images1 : "data:image/jpeg;base64," + config.noImageAvailable,
            width: 270,
            height: 250,
          },
        ],
        margin: [0, 3],
        columnGap: 5,
      },
      invoices.length > index + 1 ? {
        columns: [
          {
            image: invoice.images2 !== "" ? invoice.images2 : "data:image/jpeg;base64," + config.noImageAvailable,
            width: 270,
            height: 250,

          },
        ],
        columnGap: 5,
        pageBreak: "after",
      } : {
        columns: [
          {
            image: invoice.images2 !== "" ? invoice.images2 : "data:image/jpeg;base64," + config.noImageAvailable,
            width: 270,
            height: 250,

          },
        ],
        columnGap: 5,
      }];
      content.push(...report);
    });
    const docDefinition = {
      footer: function (currentPage, pageCount) {
        return [{ canvas: [{ type: "line", x1: 20, y1: 0, x2: 570, y2: 0, lineWidth: 1 }] },
        {
          columns: [{ text: currentPage.toString() + " of " + pageCount, alignment: "left", margin: [20, 5] },
          { text: reportData["propertyName"], alignment: "right", margin: [20, 5] }]
        }];
      },
      content: content,
      styles: {
        centered: {
          alignment: "center",
        },
        backgroundTitle: {
          background: "lightgrey",
        },
      },
    };
    // create local pdf
    const pdfDoc = printer.createPdfKitDocument(docDefinition);


    pdfDoc.on("data", (chunk) => {
      chunks.push(chunk);
    });

    pdfDoc.on("end", () => {
      const result = Buffer.concat(chunks);
      resolve({ "reportBuffer": result, "propertyName": reportData["propertyName"], "name": fileName, "dateToSend": time, "path": "violations_reports/" + fileName, "emails": reportData["emails"] });
    });

    pdfDoc.on("error", (err) => {
      reject(err);
    });

    pdfDoc.end();
  });
};

const requiresReorientation = (tags) => {
  if (tags.Orientation) {
    switch (tags.Orientation.value) {
      case 1: return false; // top-left  - no transform
      case 2: return true; // top-right - flip horizontal
      case 3: return true; // bottom-right - rotate 180
      case 4: return true; // bottom-left - should flip
      case 5: return true; // left-top - rotate 90 and flip horizontal
      case 6: return true; // right-top - rotate 90
      case 7: return true; // right-bottom - rotate 270 and flip horizontal
      case 8: return true; // left-bottom - rotate 270
      default: return false; // ... just to be safe
    }
  }

  return false;
};

const gmToBuffer = (data) => {
  return new Promise((resolve, reject) => {
    data.stream((err, stdout, stderr) => {
      if (err) {
        return reject(err)
      }
      const chunks = [];
      stdout.on("data", (chunk) => { chunks.push(chunk) })
      stdout.once("end", () => { resolve(Buffer.concat(chunks)) })
      stderr.once("data", (data) => { reject(String(data)) })
    })
  })
}

const getBase64ImageFromURL = (url) => {
  return new Promise(async (resolve, reject) => {
    try {
      const tags = await ExifReader.load(url);
      if (requiresReorientation(tags)) {
        console.log("Report: Reorienting image");
        const data = gm(request(url))
          .in("-quiet")
          .autoOrient();
        await gmToBuffer(data).then(function (buffer) {
          resolve(buffer.toString("base64"));
        }).catch(function (err) {
          console.log("Report: Error log orientation", err);
          reject(err);
        });
      } else {
        const image = await base64converter.encode(url, { string: true });
        resolve(image);
      }
    } catch (e) {
      console.log("Report: Error log or", e);
      reject(e);
    }
  });


};
