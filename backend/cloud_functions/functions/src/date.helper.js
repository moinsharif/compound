
const moment = require("moment");

exports.convertToDateServerFrom = (date) => {
    return moment(new Date(date.getFullYear(),
        date.getMonth(),
        date.getDate(),
        0,
        0,
        0,
        0)).add(moment().utcOffset() * 1, 'm').toDate();
}

exports.convertToDateServerTo = (date) => {
    return moment(new Date(date.getFullYear(),
        date.getMonth(),
        date.getDate(),
        23,
        59,
        59,
        9999)).add(moment().utcOffset() * 1, 'm').toDate();
}

exports.convertToDateLocal = (date) => {
    return moment(date).add(moment().utcOffset() * - 1, 'm').toDate();
}

exports.formatDate = (data, field, format, forceNewDates) => {

    var date = data[field].toDate();
    if (data[field + "Tz"] != null || forceNewDates) {
        return moment(date).add(moment().utcOffset() * -1, 'm').format(format);
    }

    return moment(date).utcOffset(-6, false).format(format).replace("-05:00", "");
}

exports.formatDateWithTime = (data, field, format, forceNewDates) => {

    var date = data[field].toDate();
    if (data[field + "Tz"] != null || forceNewDates) {
        var dateMoment = moment(date).add(moment().utcOffset() * -1, 'm');
        return dateMoment.format(format) + " at " + dateMoment.format("hh:mm A");
    }

    return moment(date).utcOffset(-6, false).format(format).replace("-05:00", "") + " at " + moment(date).utcOffset(-6, false).format("hh:mm A").replace("-05:00", "");
}