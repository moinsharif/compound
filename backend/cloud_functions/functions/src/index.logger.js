var debug = true; //TODO env config().debug

exports.logMessage = (type, message, userId) =>{
    if(debug){
       console.log("["+ new Date().toISOString() + "]:: " + (userId != null? userId.substring(userId.length - 5) : "") + type + " [MESSAGE]: " + message);
    }
}

exports.logError = (type, exception, userId) =>{
    console.log("["+ new Date().toISOString() + "]:: " + (userId != null? userId.substring(userId.length - 5) : "") + type + " [ERROR]: " + exception.message + " CODE:" + exception.code);
}