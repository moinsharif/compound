import 'dart:io';

import 'package:camera/camera.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_services/logs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraView>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _flashOn = false;
  double minZoomIn = 1.0;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    bool error = false;
    try {
      _cameras = await availableCameras();
      if (_cameras.length < 1) {
        throw Exception("Camera error: No cameras found");
      }
    } on CameraException catch (e1, st) {
      _showCameraException(e1);
      logException(e1, "initialize -> e1 available ", st);
      error = true;
    } on Exception catch (e2, st) {
      logException(e2, "initialize -> e2 available ", st);
      error = true;
    } catch (e3, st) {
      logException(e3, "initialize -> e3 available ", st);
      error = true;
    }

    if (!error) {
      try {
        _controller = CameraController(_cameras[0], ResolutionPreset.high,
            enableAudio: false);
      } on CameraException catch (e1, st) {
        _showCameraException(e1);
        logException(e1, "initialize -> e1 controller ", st);
        error = true;
      } on Exception catch (e2, st) {
        logException(e2, "initialize -> e2 controller ", st);
        error = true;
      }
    }

    if (!error) {
      try {
        await _controller.initialize();
      } on CameraException catch (e1, st) {
        _showCameraException(e1);
        logException(e1, "initialize -> e1 initialize ", st);
        error = true;
      } on Exception catch (e2, st) {
        logException(e2, "initialize -> e2 initialize ", st);
        error = true;
      }
    }

    if (!mounted || error) {
      locator<NavigatorService>().navigateBack();
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return Center(
        child: SizedBox(
          width: 32.w,
          height: 32.w,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraPreview() {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return ClipRect(
      child: Container(
        child: Center(
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      // color: AppTheme.instance.primaryDarker,
      height: 200.0.w,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.w),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0.w,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 28.0.sp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
          ),
          Padding(
              padding: EdgeInsets.all(15.w),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0.w,
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 28.0.sp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _captureImage();
                  },
                ),
              )),
          Padding(
              padding: EdgeInsets.all(15.w),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0.w,
                child: IconButton(
                  icon: Icon(
                    _flashOn ? Icons.flashlight_off : Icons.flashlight_on,
                    size: 28.0.sp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _flash();
                    _flashOn = !_flashOn;
                    setState(() {});
                  },
                ),
              )),
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28.0.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.zoom_in,
                        size: 28.0.sp,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await zoomIn();
                      },
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.all(15.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28.0.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.zoom_out,
                        size: 28.0.sp,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await zoomOut();
                      },
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future<FileSystemEntity> getLastImage() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    var lastFile = _images[0];
    return lastFile;
  }

  Future<void> _flash() {
    return _controller.setFlashMode(_flashOn ? FlashMode.off : FlashMode.torch);
  }

  Future<void> zoomIn() async {
    double maxZoomIn = await _controller.getMaxZoomLevel();
    if (minZoomIn < maxZoomIn) {
      minZoomIn += 1;
      await _controller.setZoomLevel(minZoomIn);
    }
  }

  Future<void> zoomOut() async {
    if (minZoomIn > 1.0) {
      minZoomIn -= 1;
      await _controller.setZoomLevel(minZoomIn);
    }
  }

  Future<void> _onCameraSwitch() async {
    if (_cameras.length < 2) {
      return;
    }

    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.high,
        enableAudio: false);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e1, st) {
      logException(e1, "switch -> e1 ", st);
      _showCameraException(e1);
    } on Exception catch (e2, st) {
      logException(e2, "switch -> e2 ", st);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    if (_controller.value.isInitialized) {
      try {
        XFile pic = await _controller.takePicture();
        locator<NavigatorService>().navigateBack(arguments: pic.path);
      } on CameraException catch (e1, st) {
        logException(e1, "capture -> e1 ", st);
        _showCameraException(e1);
      } on Exception catch (e2, st) {
        logException(e2, "capture -> e2 ", st);
      }
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void logException(Exception e, String method, stacktrace) {
    try {
      locator<LogService>().logException("camera", method, e, stacktrace);
      Crashlytics.instance.recordError(e, StackTrace.current, context: method);
    } catch (e) {}
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}
