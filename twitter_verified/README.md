# Acert-Video

Acert is an open source hashing plugin to combat social media disinformation.

This packages provides the AcertVideo class, a decorated VideoPlayer that also parses mkv and mp4 files' metadata to determine source validity. 
AcertVideo handles video playback, looping, and pausing.

## How to Use:
Below is an example of how the package would be used.

```dart
import 'package:assert_video/assert_video.dart'
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
