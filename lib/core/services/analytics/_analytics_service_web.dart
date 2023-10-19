

import 'package:flutter/foundation.dart';

class AnalyticsService {

  Future logAccessUnlockFailed(String userId) async {
  }
 
  Future setUserProperties({@required String userId, String userRole}) async {
  }

  Future logLogin() async {
  }

  Future logSignUp() async {
  }

  Future logCheckoutStart(String productId, String sku) async {
  }

  Future logCheckoutSuccess(String transactionId, String productId, String sku) async {
  }

  Future logCheckoutFailed(String productId, String sku, String code,{bool fatal = false}) async {
  }
}
