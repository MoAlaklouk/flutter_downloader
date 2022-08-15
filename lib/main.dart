import 'package:download_manager/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

   // Plugin must be initialized before using
  await FlutterDownloader.initialize(
    
    debug:true,
    ignoreSsl: true 
    // optional: set to false to disable printing logs to console (default: true)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
