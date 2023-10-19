

/*import 'package:compound/utils/view_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class VideoPlayerYoutube extends StatefulWidget {

  final String url;
  VideoPlayerYoutube({Key key, this.url}) : super(key: key);

  @override
  _VideoYoutubeState createState() => _VideoYoutubeState();
}

class _VideoYoutubeState extends State<VideoPlayerYoutube> implements YouTubePlayerListener {
     
        double _currentVideoSecond = 0.0;
        String _playerState = "";
        FlutterYoutubeViewController _controller;

        getVideoId(){
           return ViewUtils.convertUrlToYoutubeId(this.widget.url);
        }

        @override
        void onCurrentSecond(double second) {
          print("onCurrentSecond second = $second");
          _currentVideoSecond = second;
        }

        @override
        void onError(String error) {
          print("onError error = $error");
        }

        @override
        void onReady() {
          print("onReady");
        }

        @override
        void onStateChange(String state) {
          print("onStateChange state = $state");
          setState(() {
            _playerState = state;
          });
        }

        @override
        void onVideoDuration(double duration) {
          print("onVideoDuration duration = $duration");
        }

        void _onYoutubeCreated(FlutterYoutubeViewController controller) {
          this._controller = controller;
        }


        @override
        Widget build(BuildContext context) {
          return Stack(
                children: <Widget>[
                  Container(
                      child: FlutterYoutubeView(
                    onViewCreated: _onYoutubeCreated,
                    listener: this,
                    params: YoutubeParam(
                      videoId: this.getVideoId(),
                      showUI: true,
                      startSeconds: 5 * 60.0,
                      showYoutube: false,
                      showFullScreen: false,
                    ),
                  )),
                  Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Current state: $_playerState',
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ))
                ],
              );
        }
}*/

