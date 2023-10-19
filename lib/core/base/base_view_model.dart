import 'package:compound/locator.dart';
import 'package:compound/shared_services/logs_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../logger.dart';

const MESSAGE_ERROR = "Connection error, check your internet connection.";
const MESSAGE_ERROR_POSFIX = "\nPlease check the issue and tap to reload";

typedef OnRefreshCallback = Future<void> Function();

class RefreshAction {
  OnRefreshCallback callback;
  Widget errorWidget;
  Function onError;
  String uiMessage;
  bool autoUnlock;

  RefreshAction(
      {this.autoUnlock,
      this.callback,
      this.errorWidget,
      this.onError,
      this.uiMessage = MESSAGE_ERROR});
}

class BaseViewModel extends ChangeNotifier {
  String _title;

  Map<String, RefreshAction> _actionsRefreshCallback =
      Map<String, RefreshAction>();

  LogService _logService = locator<LogService>();

  bool _busy;
  bool _error = false;
  Logger log;
  bool _isDisposed = false;
  Widget errorWidget;

  BaseViewModel({
    bool busy = false,
    String title,
  })  : _busy = busy,
        _title = title {
    log = getLogger(title ?? this.runtimeType.toString());
  }

  bool get error => this._error;
  bool get busy => this._busy;
  bool get isDisposed => this._isDisposed;
  String get title => _title ?? this.runtimeType.toString();

  set busy(bool busy) {
    log.i(
      'busy: '
      '$title is entering '
      '${busy ? 'busy' : 'free'} state',
    );
    this._busy = busy;
    notifyListeners();
  }

  void handleException(Exception e, String method, stacktrace) {
    try {
      this._logService.logException(_title, method, e, stacktrace);
      Crashlytics.instance.recordError(e, StackTrace.current, context: method);
    } catch (e) {}
  }

  setError(bool error) {
    log.i(
      'busy: '
      '$title is entering '
      '${_error ? 'error' : 'non error'} state',
    );
    this._error = error;
    notifyListeners();
  }

  setBusy(bool busyVal) {
    busy = busyVal;
  }

  _buildErrorWidget(String uiMessage) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.error,
        color: AppTheme.instance.buttonPrimary,
        size: 55,
      ),
      Center(
          child: Text(
        uiMessage + MESSAGE_ERROR_POSFIX,
        textAlign: TextAlign.center,
      ))
    ]);
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    } else {
      log.w('notifyListeners: Notify listeners called after '
          '${title ?? this.runtimeType.toString()} has been disposed');
    }
  }

  @override
  void dispose() {
    log.i('dispose');
    _isDisposed = true;
    super.dispose();
  }

  showError(Function refresh, {String uiMessage = MESSAGE_ERROR}) {
    errorWidget = InkWell(
        onTap: () async {
          setBusy(true);
          setError(false);
          await Future.delayed(Duration(seconds: 1));
          refresh();
        },
        child: _buildErrorWidget(uiMessage));
    setError(true);
  }

  safeActionRefreshable(Function run,
      {bool autoUnlock = true,
      String uiMessage = MESSAGE_ERROR,
      String action = "initialization",
      Function onError}) {
    if (!_actionsRefreshCallback.containsKey(action)) {
      if (onError != null) {
        _actionsRefreshCallback[action] = RefreshAction(
            callback: run,
            uiMessage: uiMessage,
            onError: onError,
            autoUnlock: autoUnlock);
      } else {
        _actionsRefreshCallback[action] = RefreshAction(
            callback: run,
            uiMessage: uiMessage,
            errorWidget: null,
            autoUnlock: autoUnlock);
      }
    } else {
      _actionsRefreshCallback[action].callback = run;
    }

    _refresh(action);
  }

  _refresh(String action, {delayed: false}) async {
    var actionEvent = _actionsRefreshCallback[action];
    var callback = actionEvent.callback;
    if (callback != null) {
      _error = false;
      setBusy(true);
      if (delayed) await Future.delayed(Duration(seconds: 1));
      try {
         callback().then((value) {
          if (actionEvent.autoUnlock) setBusy(false);
          return null;
        }).catchError((error, stackTrace) {
          throw (error);
        });
      } catch (e) {
        log.e('Safe action error: ', e);

        if (_actionsRefreshCallback[action].onError != null) {
          _actionsRefreshCallback[action].onError(e, action);
          setBusy(false);
          return;
        }

        errorWidget = InkWell(
            onTap: () {
              _refresh(action, delayed: true);
            },
            child: _buildErrorWidget(actionEvent.uiMessage));
        setError(true);
      }
    }
  }
}
