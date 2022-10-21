import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Home.dart';
import 'package:citysight_editor/ui/AppPanel.dart';
import 'package:citysight_editor/ui/Body.dart';
import 'package:citysight_editor/utils/SystemPrefs.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

var logger = Logger();

class Auth{
  final String username;
  final String token;

  Auth({required this.username, required this.token}) : super();

  factory Auth.fromJson(Map<String, dynamic> json){
    return Auth(
      username: json['username'],
      token: json['token']
    );
  }
}

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();

}

class _LoginState extends State<Login> {
  bool session = false;
  String message = "";

  final SystemPrefs _prefs = SystemPrefs();

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _prefs.getAuthToken().then((value) => {
      if(value.isNotEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()))
      }
    });


    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _messageController.dispose();
    
    super.dispose();
  }

  Future<Auth> login(String username, String password) async {
    logger.i("User: $username Password: $password");
    final response = await http.post(
        Uri.parse('$baseContentUrl/api/v1/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control_Allow_Origin': '*'
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password
        }),
      );
    logger.d(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return Auth.fromJson(jsonDecode(response.body));
    } else if(response.statusCode == 400) {
      return Auth(username: "", token: "");
    } else {
      return Auth(username: "", token: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      isShowActions: false,
      body: Container(
          transformAlignment: Alignment.center,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Text(message),
                ),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Email or Username",
                        hintText: "Email or Username",
                        focusColor: Theme.of(context).colorScheme.primary,
                        hoverColor: Theme.of(context).colorScheme.primary,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Password",
                        focusColor: Theme.of(context).colorScheme.primary,
                        hoverColor: Theme.of(context).colorScheme.primary,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ), 
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: session, 
                        onChanged: (value){ 
                          setState(() {
                            session = value!;
                          });
                        },
                      ),
                      const Text("Saved?")
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 0, child: OutlinedButton(onPressed: () async {
                        Auth auth = await login(_usernameController.text, _passwordController.text);
                        
                        setState(() {
                          if(auth.username.isEmpty || auth.token.isEmpty){
                            message = "Неверный логин или пароль";
                            return;
                          } 

                          _prefs.setAuthToken("cisi_${auth.token}");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        });

                      }, child: const Text("Go")),),
                      Expanded(flex: 0, child: OutlinedButton(onPressed: (){

                      }, child: const Text("Sign In")),)
                    ],
                  ),
                )
              ],
            )
          ),
        )
    );
  }
}