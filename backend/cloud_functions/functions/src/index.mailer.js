const nodemailer = require("nodemailer");

var from = "hellodoorstepatx@gmail.com";

const transporter = nodemailer.createTransport({
  service: "gmail",
  secure: true,
  port: 465,
  auth: {
    user: from,
    pass: "qumaocyfwftcbqwj",
  },
});


exports.config = {origin: from, debugMail: ""};
exports.transporter = transporter;
