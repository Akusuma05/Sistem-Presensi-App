import 'package:flutter/material.dart';
import 'package:sistem_presensi_app/view/pages/Pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
      routes: {
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) => const Register(),
      },
    );
  }
}
