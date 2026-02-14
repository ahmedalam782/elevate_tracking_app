import 'package:elevate_tracking_app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('login page'),
            ElevatedButton(
              onPressed: () => context.push(Routes.apply),
              child: const Text('apply'),
            ),
          ],
        ),
      ),
    );
  }
}
