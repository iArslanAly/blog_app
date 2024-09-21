import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatefulWidget {
  const AuthGradientButton({super.key});

  @override
  State<AuthGradientButton> createState() => _AuthGradientButtonState();
}

class _AuthGradientButtonState extends State<AuthGradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppPallete.gradient1, AppPallete.gradient2],
              begin: AlignmentDirectional(0, 1),
              end: AlignmentDirectional(1, 0)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(395, 55),
              backgroundColor: AppPallete.transparent,
              shadowColor: AppPallete.transparent),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 18,
            ),
          )),
    );
  }
}
