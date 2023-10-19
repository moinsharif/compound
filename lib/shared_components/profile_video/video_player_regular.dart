
/*import 'package:compound/shared_components/profile_video/profile_video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerRegular extends StatefulWidget {

  final String url;
  VideoPlayerRegular({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayerRegularState createState() => _VideoPlayerRegularState();
}

class _VideoPlayerRegularState extends State<VideoPlayerRegular> {

    VideoPlayerController _controller;

    @override
    void initState() {
      super.initState();
      _controller = VideoPlayerController.network(this.widget.url);
      if(_controller == null)
          return;

      _controller.addListener(() {
        if (_controller.value.hasError) {
          print(_controller.value.errorDescription);
        }
        if (_controller.value.initialized) {
           _controller.play();
        }
        if (_controller.value.isBuffering) {}
      });
      _controller.initialize().then((_) => setState(() {}));
    }

    @override
    void dispose() {
      if(_controller != null)
        _controller.dispose();

      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileVideoViewModel>.reactive(
        viewModelBuilder: () => ProfileVideoViewModel(),
        builder: (context, model, child) => 
                    Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20, right: 20),
                          child:  AspectRatio(aspectRatio: _controller.value.aspectRatio,
                                              child: Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: <Widget>[
                                                  VideoPlayer(_controller),
                                                  _PlayPauseOverlay(controller: _controller),
                                                  VideoProgressIndicator(_controller, allowScrubbing: true),
                                                ],
                                              ),
                                            ),
                                          
                 ),);
  }
}


class _PlayPauseOverlay extends StatelessWidget {
      const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

      final VideoPlayerController controller;

      @override
      Widget build(BuildContext context) {
        return Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: controller.value.isPlaying
                  ? SizedBox.shrink()
                  : Container(
                      color: Colors.black26,
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                controller.value.isPlaying ? controller.pause() : controller.play();
              },
            ),
          ],
        );
      }
    }*/
