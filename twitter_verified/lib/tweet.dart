import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_verified/acert_video.dart';

class Tweet extends StatefulWidget {
  final String url, text;
  final bool verified;

  final Key key;

  Tweet(this.verified, this.text, this.url, this.key);

  factory Tweet.fromJson(bool verified, Map<String, dynamic> json) {
    String url = json['extended_entities']['media'][0]['video_info']['variants']
        [0]['url'];
    return Tweet(verified, json['full_text'], url, Key(url));
  }

  @override
  State<StatefulWidget> createState() {
    return _TweetState(verified, text, url);
  }
}

class _TweetState extends State<Tweet> {
  final String url, text;
  final bool verified;

  bool loading = true;

  _TweetState(this.verified, this.text, this.url);

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
                AcertVideo(verified, url),
                _buttonBar(),
              ],
            )));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
}
