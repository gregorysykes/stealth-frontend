import "package:flutter/material.dart";
import 'package:frontend/main.dart';
import 'package:http/http.dart' as http;
import 'otp.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage();

  // final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final secureStorage = SecureStorage();

  bool validatePassword(String password) {
    if (password.length < 8) {
      return false;
    }

    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    if (!hasLowercase) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    if (!hasUppercase) {
      return false;
    }

    bool hasSymbol = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (!hasSymbol) {
      return false;
    }

    return true;
  }

  bool isEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  //offline mode
                  if (validatePassword(_passwordController.text)) {
                    if (isEmail(_emailController.text)) {
                      await secureStorage.storeCredentials(
                          _usernameController.text, _passwordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpPage()),
                      );
                    } else {
                      print('[offline]email wrong format');
                    }
                  } else {
                    print('[offline]Password wrong format');
                  }
                  //server mode
                  var url = Uri.parse('http://10.0.2.2:3000/api/register');
                  try {
                    var response = await http.post(url, body: {
                      'name': _nameController.text,
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text
                    });

                    if (response.statusCode == 200) {
                      print(response.body);
                      //send OTP
                      await secureStorage.storeCredentials(
                          _usernameController.text, _passwordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpPage()),
                      );
                    } else {
                      print(response.body);
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
            ],
          )),
    );
  }
}

// class RegisterPage extends StatelessWidget {

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

//   }
// }
