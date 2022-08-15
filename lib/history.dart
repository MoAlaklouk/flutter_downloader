import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => HistoryPages();
}

class HistoryPages extends State<HistoryPage> {
  List<DownloadTask>? tasks = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        load();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download History')),
      body: ListView.separated(
        itemBuilder: (context, index) => Container(
          padding: EdgeInsetsDirectional.all(8),
          color: Colors.grey.shade300,
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(tasks![index].filename ?? '')),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        await FlutterDownloader.open(
                            taskId: tasks![index].taskId);
                      },
                      child: Text('open'))),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          load();
                        });
                        FlutterDownloader.remove(
                            taskId: tasks![index].taskId,
                            shouldDeleteContent: true);
                      },
                      child: Text('delete')))
            ],
          ),
        ), 

        separatorBuilder: (context, index) => SizedBox(
          height: 10,
          child: Divider(),
        ),
        itemCount: tasks!.length,
      ),
    );
  }

  load() async {
    tasks = await FlutterDownloader.loadTasks();
  }
}
