import 'package:flutter/material.dart';
import 'package:note_app/view/screen_all_notes.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.greenAccent,
          secondary: Colors.white,
        ),
      ),
      home: ScreenAllNotes(),
    );
  }
}
