import 'package:expense_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _displayNameController = TextEditingController();
  final AuthService _auth = AuthService();
  SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: "User Name"),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text.trim() !=
                    _confirmController.text.trim()) {
                  throw 'Passwords don\'t match, please check password again';
                } else {
                  _auth.register(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      displayName: _displayNameController.text.trim());
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
