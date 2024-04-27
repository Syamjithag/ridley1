import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridley/AdminImageListScreen.dart';
import 'package:ridley/adpost.dart';
import 'package:ridley/firebase_options.dart';
import 'package:ridley/signup.dart';
import 'package:ridley/signin.dart';
import 'package:ridley/splashscreen.dart';
import 'package:ridley/auditioncall.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  homepage()
    );
  }
}


