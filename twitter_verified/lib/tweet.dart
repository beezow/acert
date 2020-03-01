import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class Tweet extends StatefulWidget {
  final String url, text;
  final bool verified;

  Tweet(this.verified, this.text, this.url);

  factory Tweet.fromJson(bool verified, Map<String, dynamic> json) {
    return Tweet(
        verified,
        json['full_text'],
        json['extended_entities']['media'][0]['video_info']['variants'][0]
            ['url']);
  }

  @override
  State<StatefulWidget> createState() {
    return _TweetState(verified, text, url);
  }
}

class _TweetState extends State<Tweet> {
  String url, text;
  bool verified;

  bool loading = true;
  VideoPlayerController _controller;

  _TweetState(this.verified, this.text, this.url);

  @override
  void initState() {
    super.initState();

    if (this.mounted) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        setState(() {
          loading = false;
        });
      });
    }

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
        SizedBox(
          width: 15,
        ),
        CircleAvatar(
          child: Text('A'),
          radius: 25,
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Acert',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '@acert_video',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            SizedBox(child: Text(text), width: 300),
          ],
        )
      ],
    );
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
                  child:
                      loading ? CircularProgressIndicator() : verifiedWidget(),
                  bottom: 10,
                  right: 10,
                )
              ],
            ))
        : SizedBox(height: 200);
  }

  Widget _buttonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.black26,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.black26,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.black26,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.file_upload,
            color: Colors.black26,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                header(),
                SizedBox(
                  height: 20,
                ),
                video(),
                _buttonBar(),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
