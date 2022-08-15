import 'dart:isolate';
import 'dart:ui';
import 'package:download_manager/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int progress = 0;
  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading")!;

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((data) {
      setState(() {
        progress = data[2];
      });

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            "image Download",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            downloadFile(
                                url:
                                    'https://images.pexels.com/photos/33044/sunflower-sun-summer-yellow.jpg?cs=srgb&dl=pexels-pixabay-33044.jpg&fm=jpg');
                          },
                        ),
                        ElevatedButton(
                          child: const Text(
                            "Video Download",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            downloadFile(
                                url:
                                    'https://download.samplelib.com/mp4/sample-20s.mp4');
                          },
                        ),
                        ElevatedButton(
                          child: const Text(
                            "doc Download",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            downloadFile(
                                url:
                                    'https://file-examples.com/wp-content/uploads/2017/02/file-sample_1MB.docx ');
                          },
                        ),
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 10,
                              backgroundColor: Colors.red,
                              value:
                                  progress >= 0 ? progress.toDouble() / 100 : 0,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${progress.toString()} %',
                              style: const TextStyle(fontSize: 40),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    child: Text('downlioad History '),
                    onPressed: (() async {
                      setState(() {
                        HistoryPages().load();
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(),
                          ));
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  downloadFile({required String url}) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print("Permission deined");
    }
  }
}
