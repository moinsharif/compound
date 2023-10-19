import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppException implements Exception {
  final String service;
  final String _message;
  final String _prefix;

  AppException(this.service, this._message, this._prefix);

  String toString() {
    return "$_prefix$_message";
  }

  String getMessage() {
    return _message;
  }
}

class SignUpException extends AppException {
  SignUpException([String message])
      : super("AuthenticationService", message, "Error During registration ");

  static SignUpException create(exception) {
    if (exception.containsKey("message") && exception["message"] != null) {
      return SignUpException(exception["message"]);
    }
    var code = "none";
    try {
      code = exception["code"];
    } on NoSuchMethodError {}

    switch (code) {
      case "invalid_code":
        return SignUpException("Invalid Code, Please check your code");
        break;
      case "invalid_data":
        return SignUpException(
            "Connection error, check your internet connection and try againn");
        break;
      case "accessed_code":
        return SignUpException("The code is already claimed");
        break;
      case "expired_code":
        return SignUpException("The code is expired");
        break;
      default:
        {
          Crashlytics.instance.recordError(exception, StackTrace.current);
          return SignUpException("Unknown error");
        }
    }
  }
}

class LoginException extends AppException {
  LoginException([String message])
      : super("AuthenticationService", message, "Error During login ");

  static LoginException create(exception) {
    try {
      var code = "none";
      try {
        code = exception.code;
      } on NoSuchMethodError {}

      switch (code) {
        case "ERROR_INVALID_EMAIL":
          return LoginException("Your email address appears to be malformed.");
          break;
        case "ERROR_WRONG_PASSWORD":
          return LoginException("Invalid user or password");
          break;
        case "ERROR_USER_NOT_FOUND":
          return LoginException("User not found. Please register");
          break;
        case "ERROR_USER_DISABLED":
          return LoginException("User has been disabled");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          return LoginException("Too many requests. Try again later");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          return LoginException("Not Allowed");
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          return LoginException(
              "Connection error, check your internet connection and try again");
          break;
        default:
          return LoginException("Unknown error");
      }
    } catch (e) {
      Crashlytics.instance.recordError(e, StackTrace.current);
      return LoginException("Unknown error");
    }
  }
}

class ChangePasswordException extends AppException {
  ChangePasswordException([String message])
      : super(
            "AuthenticationService", message, "Error During change password ");

  static ChangePasswordException create(exception) {
    try {
      var code = "none";
      try {
        code = exception.code;
      } on NoSuchMethodError {
      }

      switch (code) {
        case "ERROR_WEAK_PASSWORD":
          return ChangePasswordException("Password is not strong enough.");
          break;
        case "ERROR_USER_DISABLED":
          return ChangePasswordException("User has been disabled.");
          break;
        case "ERROR_USER_NOT_FOUND":
          return ChangePasswordException("User not found. Please register");
          break;
        case "ERROR_REQUIRES_RECENT_LOGIN":
          return ChangePasswordException(
              "Please try to log in again to complete this option.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          return ChangePasswordException("Not Allowed");
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          return ChangePasswordException(
              "Connection error, check your internet connection and try again");
          break;
        default:
          return ChangePasswordException("Unknown error");
      }
    } catch (e) {
      Crashlytics.instance.recordError(e, StackTrace.current);
      return ChangePasswordException("Unknown error");
    }
  }
}

class FetchDataException extends AppException {
  FetchDataException([String service, String message])
      : super(service, message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String service, message])
      : super(service, message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String service, message])
      : super(service, message, "Unauthorized: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String service, String message])
      : super(service, message, "Invalid Input: ");
}
