import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:flutter/animation.dart';

class UploadProgressBarViewModel extends BaseViewModel {
  bool hidden = true;
  var progress = 0.0;
  var description = "";
  final UIService _uiService = locator<UIService>();
  AnimationController _controller;

  StreamSubscription<Map<String, dynamic>> events;

  @override
  dispose() {
    if (events != null) events.cancel();
    super.dispose();
  }

  Future<void> load() async {
    if (events != null) {
      events.cancel();
    }

    events = _uiService.uploadFilesStream.listen((event) {
      if (event["type"] == "begin") {
        hidden = false;
        description = event["description"];
        progress = 0.15;
      } else if (event["type"] == "success") {
        hidden = true;
        description = "";
        progress = 0;
      } else if (event["type"] == "error") {
        hidden = true;
        description = "";
        progress = 0;
      } else if (event["type"] == "progress") {
        progress = event['value'];
      }
      this.notifyListeners();
    });
  }
}
