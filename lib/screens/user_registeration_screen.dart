import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/user_registeration_controller.dart';

class UserRegistrationPage extends StatelessWidget {
  const UserRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.put(RegistrationController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'User Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey, // Form key from controller
          child: Column(
            children: [
              // Last Name
              TextFormField(
                controller: controller.nameController.value,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: controller.emailController.value,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Mobile Number
              TextFormField(
                controller: controller.mobileController.value,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid mobile number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // Notification Token (for now, we are hardcoding)
              TextFormField(
                controller: controller.notificationTokenController.value,
                decoration: InputDecoration(
                  labelText: 'Notification Token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid notification token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              Obx(() {
                return ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.registerApi();
                    } else {
                      Get.snackbar(
                        'Validation Failed',
                        'Please enter valid information in all fields',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color.from(
                            alpha: 1, red: 1, green: 1, blue: 1),
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
