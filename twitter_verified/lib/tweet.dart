import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tweet extends StatelessWidget {
  String username, tweet;

  Tweet(String username, String tweet);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text('there'),
        subtitle: Text('hello'),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }
}