//

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // Reactive variables
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final String apiUrl = "https://dummyjson.com/auth/login";

  // Method to validate email
  bool isValidEmail() {
    return email.value.isNotEmpty && email.value.contains('@');
  }

  // Method to validate password
  bool isValidPassword() {
    return password.value.length >= 6;
  }

  // Login method to call the API
  Future<void> login() async {
    isLoading.value = true;

    // Validate email and password first
    if (!isValidEmail() || !isValidPassword()) {
      errorMessage.value = 'Invalid email or password';
      isLoading.value = false;
      return;
    }

    try {
      // Prepare the payload for the API request
      final Map<String, String> requestBody = {
        "email": email.value,
        "password": password.value,
      };

      // Make the API call using POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Parse the response body
        final decodedResponse = jsonDecode(response.body);

        // Check if the login is successful (this depends on your API response)
        if (decodedResponse['success'] == true) {
          Get.snackbar(
            'Success',
            'Login successful!',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to home screen after successful login
          Get.offNamed('/home');
        } else {
          errorMessage.value = 'Invalid email or password';
        }
      } else {
        errorMessage.value =
            'Failed to connect to the server. Status: ${response.statusCode}';
      }
    } catch (e) {
      // Handle any error during the API call
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
