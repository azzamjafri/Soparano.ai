import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:soprano_video/VideoPlayer/video_player.dart';

class Downloader extends StatefulWidget {
  @override
  DownloaderState createState() {
    return new DownloaderState();
  }
}

class DownloaderState extends State<Downloader> {
  var address;
  File file;
  String _localPath;
  final url = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8";
  // "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
  bool downloading = true;
  var progressString = "";

  @override
  void initState() {
    super.initState();

    getPath();
    _saveVideo();

    //  WidgetsFlutterBinding.ensureInitialized();
    //   FlutterDownloader.initialize(
    //       debug: true // optional: set false to disable printing logs to console
    //   );

    // _requestDownload();

    // downloadVideo(url, 'demo.mp4');
    // downloadFile(url);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Video Downloaded"),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => VideoDemo(file, file.uri)));
                    },
                    child: Text("Play"),
                  )
                ],
              ),
      ),
    );
  }

  Future<void> downloadVideo(String url, String fileName) async {
    HttpClient httpClient = new HttpClient();

    String filePath = '';
    String myUrl = '';
    String dir = (await getApplicationDocumentsDirectory()).path;
    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        print("****************************PHLA");
        print(file.uri.toString());
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    print("****************************Dusra");
    address = filePath;
    print(address);
    // return filePath;
  }

  // DIO //

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    try {
      await dio.download(url, "${dir.path}/demo.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        // print("${dir.path}");
        setState(() {
          downloading = true;
          print("********");
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      file = File("${dir.path}/demo.mp4");
      // print(file.exists().toString());
    });
    print("*************************************");
    print("Download completed");
    print("*************************************");
    // _controller = VideoPlayerController.network("$url");
  }

// FLUTTER DOWNLOADER

  void getPath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    _localPath = '$appDocumentsPath/demo.mp4';
  }

  // void _requestDownload() async {

  //    await FlutterDownloader.enqueue(
  //       url: url ,
  //       headers: {"auth": "test_for_sql_encoding"},
  //       savedDir: _localPath,
  //       showNotification: true,
  //       openFileFromNotification: true);
  // }

  // IMAGE GALLERY SAVER

  _saveVideo() async {
    print("AAAYGA");
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    await Dio().download("https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    setState(() {
      downloading = false;
    });
    print(result);
  }
}
