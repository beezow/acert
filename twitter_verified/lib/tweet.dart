import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tweet extends StatelessWidget {
  final String username, tweet;

  Tweet(this.username, this.tweet);

  factory Tweet.fromJson(Map<String, dynamic> json) {
    // for (var key in json.keys) {
    //   print(key);
    // }
    print(json['user']['screen_name']);


    return Tweet(json['id_str'], json['full_text']);

  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(username),
        subtitle: Text(tweet),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }
}