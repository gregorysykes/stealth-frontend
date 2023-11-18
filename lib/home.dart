import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/main.dart';

class HomePage extends StatefulWidget {
  // const HomePage();

  // final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _otpController = TextEditingController();
  final secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 60.0),
        Center(
            child: Text(
          'WelC0me to M4ntRa',
          style: TextStyle(color: Colors.greenAccent),
        )),
        ElevatedButton(
            onPressed: () async {
              await secureStorage.clearCredentials();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Log Out'))
      ]),
    );
  }
}
