import 'package:flutter/material.dart';

class UploadImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;

  const UploadImage({super.key, required this.onPressed, this.text});

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
        // ButtonStyle(
        //   padding: const MaterialStatePropertyAll(
        //     EdgeInsets.all(8),
        //   ),
        //   backgroundColor: MaterialStatePropertyAll(Colors.white),
        //   iconColor: MaterialStatePropertyAll(
        //     Colors.grey.shade700,
        //   ),
        //   foregroundColor: MaterialStatePropertyAll(Colors.grey.shade700),
        //   elevation:
        //       const MaterialStatePropertyAll(0), //this removes box shadow

        //   shape: MaterialStatePropertyAll(OutlinedBorder(side: ))
        // ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text ?? 'Image',
                overflow: TextOverflow.ellipsis,
              ),
            ), // <-- Text
            const Icon(
              // <-- Icon
              Icons.upload,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
