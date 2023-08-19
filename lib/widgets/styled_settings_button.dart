import 'package:flutter/material.dart';

class StyledSettingsButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final double width;

  const StyledSettingsButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF00A2FF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Center(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
