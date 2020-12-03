import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  File filePath;
  Uri fileUri;
  VideoDemo(File path, Uri f) {
    filePath = path;
    fileUri = f;
    print(
        filePath.exists().then((value) => print(value.toString() + " AZZAM")));
  }
  @override
  VideoDemoState createState() {
    return new VideoDemoState();
  }
}

class VideoDemoState extends State<VideoDemo> {
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;

  // final url = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8";
  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    super.initState();
    File f = File.fromUri(widget.fileUri);
    
    _controller = VideoPlayerController.file(f);

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
        child: downloading
            ? Container(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Downloading File: $progressString",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Text("Video Downloaded"),
                  SizedBox(
                    height: 150.0,
                    width: 150.0,
                                      child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
