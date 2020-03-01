# Acert-Video

Acert is an open source hashing plugin to combat social media disinformation.

This packages provides the AcertVideo class, a decorated VideoPlayer that also parses mkv and mp4 files' metadata to determine source validity. 
AcertVideo handles video playback, looping, and pausing.

This also provides an example app hooked up to the Twitter API to provide Twitter mp4 signing verification.

## How to Use:
Below is an example of how the package would be used.

```dart
import 'package:assert_video/assert_video.dart';
import 'package:flutter/material.dart';


void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  // Example stock mp4 url
  final String url = 'https://www.pexels.com/video/854520/download/?search_query=&tracking_id=d4ep2dp6l0w'

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acert Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acert Video Dmeo'),
        ),
        body: Center(
          child: AcertVideo(url),
        ),
      ),
    );
  }
}
```

# Installation
First add `acert-video` as a dependency in pubspec.yaml 

## Android
Ensure the following permission is present in your Android Manifest file, located in 
`<project root>/android/app/src/main/AndroidManifest.xml`

```gradle
<uses-permission android:name="android.permission.INTERNET"/>
```

## iOS
Add the following entry to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`
```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

# Parameters
Acert-video offers options to test playback.
| option   | type | description                                                          |
|----------|------|----------------------------------------------------------------------|
| loopback | bool | Sets video loopback after the video finishes, defaults to true       |
| autoPlay | bool | Sets the initial state of the video when launched, defaults to false |
| mute     | bool | Sets whether the video plays sound or not                            |
