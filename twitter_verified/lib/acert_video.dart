import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class AcertVideo extends StatefulWidget {
  bool verified;
  String url;

  AcertVideo(this.verified, this.url);

  @override
  State<StatefulWidget> createState() {
    return _AcertVideoState(verified, url);
  }
}

class _AcertVideoState extends State<StatefulWidget> {
  String url;
  bool verified;

  bool loading = true;
  VideoPlayerController _controller;

  _AcertVideoState(this.verified, this.url);

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Positioned(
                  child:
                      loading ? CircularProgressIndicator() : verifiedWidget(),
                  bottom: 10,
                  right: 10,
                )
              ],
            ))
        : SizedBox(height: 200);
  }

  Widget verifiedWidget() {
    return verified
        ? FloatingActionButton.extended(
            onPressed: () {},
            label: Text('acert'),
            icon: Icon(Icons.check),
            backgroundColor: Colors.green,
          )
        : CircleAvatar(
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        loading = false;
      });
    });

    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
