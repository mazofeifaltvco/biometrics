import 'package:flutter/material.dart';
import 'package:local_auth_fingerprint/auth_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Biometrics Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthPath());
  }
}
