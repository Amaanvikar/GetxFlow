import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    controller.checkUserSession();
  }

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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey, // Associate the formKey with the Form widget
          child: Column(
            children: [
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter Email id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid Email id';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.passwordController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Enter Login Pass',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              Obx(() {
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      controller.loginApi();
                    } else {
                      Get.snackbar(
                        'Validation Failed',
                        'Please enter a valid 10-digit mobile number',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    }
                  },
                  child: controller.isloading.value
                      ? CircularProgressIndicator()
                      : Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
