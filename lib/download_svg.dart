import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadSVG extends StatefulWidget {
  @override
  _DownloadSVGState createState() => _DownloadSVGState();
}

class _DownloadSVGState extends State<DownloadSVG> {
  final imgUrl =
      "https://raw.githubusercontent.com/rohit1814/flutter_open_whatsapp/master/lib/flutter_open_whatsapp.dart";
  // "https://drive.google.com/uc?id=1aPG4aMSP4TWTXBLRA0qK0lbNucFJYncX&export=download";
  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Download File"),
            onPressed: () async {
              var tempDir = await getTemporaryDirectory();
              String fullPath = tempDir.path + "/boo2.dart";
              print('full path ${fullPath}');

              download2(dio, imgUrl, fullPath);
            },
          ),
          RaisedButton(
            child: Text("readCounter"),
            onPressed: () async {
              readCounter();
            },
          )
        ],
      ),
    );
  }

  Future<int> readCounter() async {
    final directory = await getApplicationDocumentsDirectory();

    try {
      final file = File("/data/user/0/com.bmelika.car_insurance_demo/cache/boo2.dart");

      // Read the file
      String contents = await file.readAsString();
      print(contents);
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return 0;
    }
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      print(response.statusCode);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      String contents = await file.readAsString();
      print(contents);
      await raf.close();
    } catch (e) {
      print("errrroooooe $e");
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
