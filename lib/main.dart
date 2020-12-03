import 'package:flutter/material.dart';
import 'package:soprano_video/VideoPlayer/downloader.dart';
import 'package:soprano_video/VideoPlayer/video_player.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soprano.ai Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Downloader(),
    );
  }
}
