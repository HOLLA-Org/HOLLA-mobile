import 'package:flutter/material.dart';

class LoginSreen extends StatelessWidget {
  const LoginSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Screen', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
