import 'package:flutter/material.dart';

class SelectCatBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;

  const SelectCatBtn({Key? key, required this.onPressed, this.text})
      : super(key: key); // Use super() without arguments

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 250,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF00A2FF),
          ),
          borderRadius: BorderRadius.circular(8)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text ?? 'Select Category',
                overflow: TextOverflow.ellipsis,
              ),
            ), // <-- Text
            const Icon(
              // <-- Icon
              Icons.menu_open,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
