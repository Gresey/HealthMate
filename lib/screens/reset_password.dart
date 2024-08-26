import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPassword({super.key});

  bool isPasswordMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Enter new password',
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (isPasswordMatch()) {
                  // Perform password change logic here
                  // You can navigate to a success screen or show a toast message
                } else {
                  // Show an error message indicating passwords don't match
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}