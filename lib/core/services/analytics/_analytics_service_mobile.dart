import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties({@required String userId, String userRole}) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name: 'roles', value: userRole);
  }

  Future logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  /*Future logRefundStart(String transactionId, String productId, String sku) async {
     await _analytics.logEvent(name: "iap_refund_start", parameters: {
       "transaction_id" : transactionId,
       "product_id": productId,
       "sku": sku
    });
  }

  Future logRefundSuccess(String transactionId, String productId, String sku) async {
     await _analytics.logEvent(name: "iap_refund_success", parameters: {
       "transaction_id" : transactionId,
       "product_id": productId,
       "sku": sku
    });
  }*/

  Future logAccessUnlockFailed(String userId) async {
    await _analytics.logEvent(name: "iap_access_unlock_failed", parameters: {
       "user_id": userId
    });
  }

  Future logCheckoutStart(String productId, String sku) async {
    await _analytics.logEvent(name: "iap_checkout_start", parameters: {
       "product_id": productId,
       "sku": sku
    });
  }

  Future logCheckoutSuccess(String transactionId, String productId, String sku) async {
    await _analytics.logEvent(name: "iap_checkout_success", parameters: {
       "transactionId" : transactionId,
       "product_id": productId,
       "sku": sku
    });
  }

  Future logCheckoutFailed(String productId, String sku, String code,{bool fatal = false}) async {
    await _analytics.logEvent(name: "iap_checkout_failed", parameters: {
       "product_id": productId,
       "sku": sku,
       "code" : code,
       "fatal" : fatal
    });
  }
}
