import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://klhdtycchyoxnfyxcvwt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtsaGR0eWNjaHlveG5meXhjdnd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg4Mzc5MTcsImV4cCI6MTk5NDQxMzkxN30.FvSw0KxdW-0F7Pm0sNG5Kod1XxAxvLWrovTJxfdmnxs',
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: App(),
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Lista zakupów",
            style: TextStyle(color: Color.fromARGB(255, 62, 62, 62), fontSize: 18),
          ),
          backgroundColor: Colors.greenAccent,
        ),
      ),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
