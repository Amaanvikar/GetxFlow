import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorMessage = 'incorrect username or email';
  bool isLoading = true;
  bool isSuccess = true;

  final String apiUrl = "https://dummyjson.com/auth/login";

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = 'incorrect username or email';
      isSuccess = true;
    });

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    try {
      Map<String, dynamic> requestBody = {
        "Username": username,
        "Password": password,
        "expiresInMins": 30,
      };

      Uri finalUri = Uri.parse(apiUrl);
      final response = await http.post(
        finalUri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print(response.toString());
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final decodedresponse = jsonDecode(response.body);
        print(decodedresponse);

        Get.snackbar(
          'Success', // Title of the snackbar
          'Login successful!', // Message
          snackPosition: SnackPosition.BOTTOM,
        );

        /// Navigate to homepage on successfull login
        Get.offNamed('/home');
      } else {
        setState(() {
          errorMessage =
              'Failed to connect to the server. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email Id',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
