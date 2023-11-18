import "package:flutter/material.dart";
import 'package:frontend/home.dart';
import 'package:frontend/main.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpPage extends StatefulWidget {
  // const OtpPage();

  // final String title;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool _otpButtonDisabled = true;
  String otpReq = 'wait 30s';
  Future<void> _login(otp) async {}

  void _startTimer() {
    setState(() {
      _otpButtonDisabled = true;
      otpReq = 'wait 30s';
    });

    Timer(Duration(seconds: 30), () {
      setState(() {
        _otpButtonDisabled = false;
        otpReq = 'request new otp';
        print(otpReq);
      });
    });
  }

  Future<void> _requestOTP() async {
    var url = Uri.parse('http://10.0.2.2:3000/api/sendOTP');
    // var headers = {
    //   'Content-Type': 'application/json'
    // };
    try {
      var response = await http.post(
        url,
        // headers: headers,
        // body: json.encode(), // Encode user data to JSON
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        _startTimer();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Controllers for each text field
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  // Focus nodes for each text field
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 30), () {
      setState(() {
        _otpButtonDisabled = false;
        otpReq = 'request new otp';
      });
    });
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].clear();
        }
      });
    }
  }

  // final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input OTP'),
      ),
      body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_controllers.length, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 &&
                            index < _controllers.length - 1) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              ElevatedButton(
                  child: Text('Confirm OTP'),
                  onPressed: () async {
                    String _otp = '';
                    for (var num in _controllers) {
                      _otp += num.text;
                    }
                    //offline mode
                    if (_otp == '111111') {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      print('[Offline] OTP wrong');
                    }

                    //server mode
                    var url = Uri.parse('http://10.0.2.2:3000/api/validateOTP');
                    try {
                      var response = await http.post(
                        url,
                        // headers: headers,
                        body: {"otp": _otp},
                      );

                      if (response.statusCode == 200) {
                        if (response.body == 'Success') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          print('wrong otp');
                        }
                      } else {
                        print(
                            'Request failed with status: ${response.statusCode}.');
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  }),
              ElevatedButton(
                  child: Text(otpReq),
                  onPressed: _otpButtonDisabled ? () {} : _requestOTP),
            ],
          )),
    );
  }
}
