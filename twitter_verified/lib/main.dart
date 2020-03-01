import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:tweet_ui/models/api/tweet.dart';
// import 'package:tweet_ui/tweet_ui.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:twitter_verified/tweet.dart';
import 'secrets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Teddy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _twitterOauth = new twitterApi(
      consumerKey: Secrets.consumerKey,
      consumerSecret: Secrets.consumerSecret,
      token: Secrets.token,
      tokenSecret: Secrets.tokenSecret);

  List<Widget> _tweets = [];

  Future<dynamic> getTweets() async {
    return _twitterOauth.getTwitterRequest(
      // Http Method
      "GET",
      // Endpoint you are trying to reach
      "statuses/user_timeline.json",
      // The options for the request
      options: {
        "screen_name": "acent_video",
        "count": "20",
        "trim_user": "true",
        "tweet_mode": "extended", // Used to prevent truncating tweets
      },
    );
  }

  Future<Null> _refresh() async {
    return getTweets().then((_response) {
      List<Widget> newWidgets = [];
      var body = jsonDecode(_response.body);
      int i = body.length - 1;

      setState(() => _tweets = []);

      for (var item in body) {
        newWidgets.add(Tweet.fromJson(i % 3 != 2, item));
        i--;
      }
      setState(() {
        _tweets = newWidgets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Text('Mail'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        body: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: _tweets.length,
                itemBuilder: (context, index) => _tweets[index])));
  }
}
