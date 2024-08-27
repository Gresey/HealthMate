// @dart=2.17
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _auth = AuthService();

  void _resetPassword() async {
    try {
      await _auth.sendPasswordResetLink(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password reset link sent to your email address.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              ),
      Positioned(
            top: 100,
            right: -80,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade500,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),
       
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 240,
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Forget Password',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 27,
                                )),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple, // Text color
                            minimumSize:
                                Size(double.infinity, 40), // Width and height
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0), // Horizontal padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                          onPressed: _resetPassword,
                          child: Text('Reset Password'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
