import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final void Function()? onTap;
  final String? selectedTime;
  const TimePicker({super.key, this.onTap, this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFF00A2FF),
          ),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            selectedTime ?? "Select TIme",
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.access_time,
            size: 20,
          ),
        ]),
      ),
    );
  }
}
