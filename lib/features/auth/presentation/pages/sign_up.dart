import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              AuthField(hintText: 'Name'),
              SizedBox(height: 20),
              AuthField(hintText: 'Email'),
              SizedBox(height: 20),
              AuthField(hintText: 'Password'),
            ],
          ),
        ),
      ),
    );
  }
}
