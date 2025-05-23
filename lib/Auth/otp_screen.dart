import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final String mobileNumber =
      Get.arguments['mobile']; // Get mobile number from arguments
  RxBool isLoading = false.obs;

  Future<void> verifyOtp() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("https://windhans.com/2022/hrcabs/verifyUserOTP"),
        body: {
          'reg_mobile': mobileNumber,
          'otp_number': '123456',
          'is_new_user': '0',
          'reg_notification_token': "",
        },
      );

      var data = jsonDecode(response.body);
      isLoading.value = false;

      print('OTP Verification Response: $data');

      if (response.statusCode == 200 && data['result'] == true) {
        print('OTP Verified Successfully! Navigating to Home Screen.');

        // Save token or user details if needed
        String token = data['user_detail']['sToken'];
        print("User Token: $token");
        print('Received OTP: ${data['user_detail']['reg_otp']}');

        Get.snackbar('Success', 'OTP Verified Successfully');
        Get.offAllNamed(
            '/home'); // Navigate to Home Page after successful verification
      } else {
        print('OTP Verification Failed: ${data['reason']}');
        Get.snackbar(
            'OTP Verification Failed', data['reason'] ?? 'Invalid OTP');
      }
    } catch (e) {
      isLoading.value = false;
      print('Exception: $e');
      Get.snackbar('Exception', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP sent to $mobileNumber',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'OTP'),
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: isLoading.value ? null : verifyOtp,
                child: isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
