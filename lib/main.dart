import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:caffe/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow(null, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: "UbuntuSans",
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16.0)),
      ),
      home: const Home(),
    );
  }
}
