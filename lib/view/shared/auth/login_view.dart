import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/shared/auth_view_model.dart';

class LoginView extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                await _authViewModel.login(email, password);
                if (_authViewModel.isLoggedIn) {
                  Get.offAllNamed(RouteName.patientHome);
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(RouteName.signup);
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
