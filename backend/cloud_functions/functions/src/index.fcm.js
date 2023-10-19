



exports.sendPushNotification = async (admin, title, message, fcmToken, room) => {

    const payload = {
        token: fcmToken,
        notification: {
            title: title,
            body: message
        },
        data: {
            title: title,
            body: message,
            type : "FCM",
            owner : room["owner"],
            id :  room["id"],
            nickname :  room["nickname"],
            photoUrl : ""
        }
    };

    console.log(JSON.stringify(payload['data'], undefined, 2));
    
    admin.messaging().send(payload).then((response) => {
        console.log('Successfully sent message:', response);
        return {success: true};
    }).catch((error) => {
        return {error: error.code};
    });
}