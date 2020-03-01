import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tweet_webview/tweet_webview.dart';
import 'package:video_player/video_player.dart';

class Tweet extends StatefulWidget {
  final String url, text;

  Tweet(this.text, this.url);

  factory Tweet.fromJson(Map<String, dynamic> json) {
    // for (var key in json.keys) {
    //   print(key);
    // }

    print(json['full_text']);
    return Tweet(
        json['full_text'],
        json['extended_entities']['media'][0]['video_info']['variants'][0]
            ['url']);
  }

  @override
  State<StatefulWidget> createState() {
    return _TweetState(text, url);
  }
}

class _TweetState extends State<Tweet> {
  String url, text;
  VideoPlayerController _controller;

  _TweetState(this.text, this.url);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
        });
      });
  }

  Widget header() {
    return Row(
      children: <Widget>[
        FlutterLogo(
          size: 50,
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Acert',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '@acert_video',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ],
            ),
            Text(text)
          ],
        )
      ],
    );
  }

  Widget video() {
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
                  child: CircularProgressIndicator(),
                  bottom: 10,
                  right: 10,
                )
              ],
            ))
        : Container();
  }

  Widget _buttonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(icon: Icon(Icons.message)),
        IconButton(icon: Icon(Icons.refresh)),
        IconButton(icon: Icon(Icons.favorite)),
        IconButton(icon: Icon(Icons.file_upload)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                header(),
                video(),
                _buttonBar(),
              ],
            )));
  }
}
