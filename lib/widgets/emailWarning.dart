import 'package:flutter/material.dart';

class EmailWarning extends StatelessWidget {
  const EmailWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
              ),
              SizedBox(
                  width: 4), // Adding a small gap between the icon and text
              Flexible(
                child: Text(
                  "Please enter your valid email",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "then a password reset link will be sent to your email.",
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
