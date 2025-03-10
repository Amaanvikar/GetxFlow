// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getxflow/controller/login_controller.dart';
// import 'package:http/http.dart' as http;

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   String errorMessage = 'incorrect username or email';
//   bool isLoading = true;
//   bool isSuccess = true;

//   final String apiUrl = "https://dummyjson.com/auth/login";

//   Future<void> login() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = 'incorrect username or email';
//       isSuccess = true;
//     });

//     String username = usernameController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     try {
//       Uri finalUri = Uri.parse(apiUrl).replace(
//         queryParameters: {
//           "Username": username,
//           "Email ID": email,
//           "Password": password,
//         },
//       );

//       final response = await http.get(finalUri);
//       print(response.toString());
//       setState(() {
//         isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         final decodedresponse = jsonDecode(response.body);
//         print(decodedresponse);

//         Get.snackbar(
//           'Success', // Title of the snackbar
//           'Login successful!', // Message
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         /// Navigate to homepage on successfull login
//         Get.offNamed('/home');
//       } else {
//         setState(() {
//           errorMessage =
//               'Failed to connect to the server. Status: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'An error occurred: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LoginController controller = Get.put(LoginController());

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Login Page',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                   labelText: 'Email Id',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: login, child: Text('Login')),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());
  // Instantiate the controller
  @override
  Widget build(BuildContext context) {
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
            // Email TextField
            TextField(
              onChanged: (value) =>
                  controller.email.value = value, // Bind to email variable
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Password TextField
            TextField(
              obscureText: true,
              onChanged: (value) => controller.password.value =
                  value, // Bind to password variable
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Show error message if exists
            Obx(() {
              return controller.errorMessage.isNotEmpty
                  ? Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container();
            }),

            // Show loading indicator when isLoading is true
            Obx(() {
              return controller.isLoading.value
                  ? CircularProgressIndicator() // Show loading indicator while loading
                  : ElevatedButton(
                      onPressed: () {
                        if (controller.isValidEmail() &&
                            controller.isValidPassword()) {
                          controller
                              .login(); // Call the login method when button is pressed
                        } else {
                          controller.errorMessage.value =
                              'Please enter valid credentials';
                        }
                      },
                      child: Text('Login'),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
