const Printer = require("pdfmake");

const config = require("./index.config");
const mailer = require("./index.mailer");
const fonts = require("pdfmake/build/vfs_fonts.js");
const base64converter = require("node-base64-image");
const fontDescriptors = {
  Roboto: {
    normal: Buffer.from(fonts.pdfMake.vfs["Roboto-Regular.ttf"], "base64"),
    bold: Buffer.from(fonts.pdfMake.vfs["Roboto-Medium.ttf"], "base64"),
    italics: Buffer.from(fonts.pdfMake.vfs["Roboto-Italic.ttf"], "base64"),
    bolditalics: Buffer.from(fonts.pdfMake.vfs["Roboto-Italic.ttf"], "base64"),
  },
};

exports.sendEmailWatchlistReports = async (bucket, db, data) => {
  return new Promise(async (resolve, reject) => {
    try {
      const documents = await generatePropertyReports(db, data);
      for (let i = 0; i < documents.length; i++) {
        const reportUrl = await saveReportFile(bucket, documents[i]);
        for (let j = 0; j < documents[i].emails.length; j++) {
          await sendMail(reportUrl, documents[i], documents[i].emails[j]);
        }
      }

      resolve({result: {status: 200}});
    } catch (e) {
      reject({result: {status: 500, error: e}});
    }
  });
};

async function saveReportFile(bucket, document) {
  return new Promise(async (resolve, reject) => {
    const fileRef = bucket.file(
        document["path"],
        {
          metadata: {contentType: "application/pdf"},
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
  const mailOptions = {
    from: mailer.config.origin,
    to: email,
    subject: "Hellodoorstep - Watchlist Report - " + document["propertyName"],
    attachments: [
      {
        filename: document["name"],
        path: reportUrl,
      },
    ],
    html: "<p style=\"font-size: 16px;\">Watchlist reports</p><br />",
  };

  return mailer.transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log("Error sending mail " + error);
      return {
        result: {status: 500, error: error},
      };
    }
    return {result: {status: 200, success: "sent"}};
  });
}


async function generatePropertyReports(db, data) {
  const ids = data["watchlistIds"];
  console.log("IDS " + ids);
  const reports = {};
  for (let i = 0; i < ids.length; i++) {
    const watchlistDb = await db.collection("watchlist").doc(ids[i]).get();
    if (watchlistDb.exists) {
      const watchlistData = watchlistDb.data();
      const propertyId = watchlistData["propertyId"];
      const propertyDb = await db.collection("properties").doc(propertyId).get();
      if (propertyDb.exists) {
        const propertyData = propertyDb.data();
        if (propertyData["emails"] == null || propertyData["emails"].length < 1) {
          continue; // TODO show error
        }
        if (reports[propertyId] == null) {
          reports[propertyId] = {"propertyName": propertyData["propertyName"], "emails": propertyData["emails"], "watchlist": []};
        }

        reports[propertyId]["watchlist"].push(watchlistData);
      }
    }
  }

  const generatedReports = [];
  for (const attr in reports) {
    const reportData = reports[attr];
    generatedReports.push(await generatePdf(reportData));
  }
  return generatedReports;
}

const generatePdf = (reportData) => {
  return new Promise(async (resolve, reject) => {
    const printer = new Printer(fontDescriptors);
    const chunks = [];

    const content = [
      {
        text: "Photo report by " + config.brand,
        fontSize: 12,
        style: ["centered", "backgroundTitle"],
        margin: [0, 45],
      },
      {
        image: config.brandIcon,
        width: 200,
        style: ["centered"],
        margin: [0, 45],
      },
      {
        text: reportData["propertyName"],
        fontSize: 50,
        style: ["centered"],
        margin: [0, 100],
        pageBreak: "after",
      }];
    const docDefinition = {
      footer: function(currentPage, pageCount) {
        return [{canvas: [{type: "line", x1: 20, y1: 0, x2: 570, y2: 0, lineWidth: 1}]},
          {columns: [{text: currentPage.toString() + " of " + pageCount, alignment: "left", margin: [20, 5]},
            {text: reportData["propertyName"], alignment: "right", margin: [20, 5]}]}];
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

    for (let i = 0; i < reportData["watchlist"].length; i++) {
      const imageUri = reportData["watchlist"][i]["image"];
      try {
        var imageBase64 = await getBase64ImageFromURL(imageUri);
      } catch (e) {
        console.log("Error generating base64 image " + imageUri);
        console.log(e);
        continue;
      }
      const violationContent = {
        columns: [
          {
            stack: [
              {text: ""+ (i + 1) + "", bold: true, fontSize: 15},
              "Unit: "+ reportData["watchlist"][i]["name"],
              // "Date: " + reportData["watchlist"][i]["date"].toDate().toISOString().
              //     replace(/T/, " ").
              //     replace(/\..+/, ""),
              "Creator: " + reportData["watchlist"][i]["porterName"],
            ],
            fontSize: 12,
          },
          [{
            image: "data:image/jpeg;base64," + imageBase64,
            width: 150,
          }],
        ],
        margin: [0, 50],
      };
      content.push(violationContent);
    }
    // console.log("CONTENT");
    // console.log(JSON.stringify(docDefinition));
    const pdfDoc = printer.createPdfKitDocument(docDefinition);

    pdfDoc.on("data", (chunk) => {
      chunks.push(chunk);
    });

    pdfDoc.on("end", () => {
      const result = Buffer.concat(chunks);
      const time = new Date().getTime();
      const fileName = "Incident_Report_" + reportData["propertyName"] + "_" + time + ".pdf";
      resolve({"reportBuffer": result, "propertyName": reportData["propertyName"], "name": fileName, "path": "violations_reports/" + fileName, "emails": reportData["emails"]});
    });

    pdfDoc.on("error", (err) => {
      reject(err);
    });

    pdfDoc.end();
  });
};

const getBase64ImageFromURL = (url) => {
  return new Promise(async (resolve, reject) => {
    const image = await base64converter.encode(url, {string: true});
    resolve(image);
  });
};
