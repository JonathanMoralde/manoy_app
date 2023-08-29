import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';

class AppointmentsListsPage extends StatefulWidget {
  const AppointmentsListsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsListsPage> createState() => _AppointmentsListsPageState();
}

class _AppointmentsListsPageState extends State<AppointmentsListsPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('APPOINTMENTS'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('shopId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final appointments = snapshot.data!.docs;

                final containerWidth = MediaQuery.of(context).size.width * 0.9;

                return Column(
                  children: appointments.map((appointment) {
                    final appointmentData =
                        appointment.data() as Map<String, dynamic>;
                    final date = appointmentData['date'] as Timestamp;
                    final email = appointmentData['email'] as String;
                    final time = appointmentData['time'] as String;

                    final DateTime dateTime = date.toDate();
                    final year = dateTime.year;
                    final month = dateTime.month;
                    final day = dateTime.day;

                    final formattedDate = '$year-$month-$day';

                    return GestureDetector(
                      onTap: () {
                        _showConfirmationDialog(
                            context, formattedDate, email, time);
                      },
                      child: Container(
                        width: containerWidth,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: $formattedDate'),
                            Text('Email: $email'),
                            Text('Time: $time'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context,
      String formattedDate, String email, String time) async {
    bool? isConfirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Appointment'),
          content: Text('Do you want to confirm or reject the appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Reject
              },
              child: Text('Reject'),
            ),
          ],
        );
      },
    );

    if (isConfirmed != null && !isConfirmed) {
      _showRejectReasonDialog(context, formattedDate, email, time);
    }
  }

  Future<void> _showRejectReasonDialog(BuildContext context,
      String formattedDate, String email, String time) async {
    String? selectedReason = await showDialog(
      context: context,
      builder: (context) {
        String? reason;

        return AlertDialog(
          title: Text('Reject Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select a reason for rejection:'),
              StyledDropdown(
                value: reason,
                onChange: (newValue) {
                  setState(() {
                    reason = newValue;
                  });
                },
                hintText: 'Select a reason', // Set your hint text here
                items: [
                  'Reason 1',
                  'Reason 2',
                  'Reason 3',
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop the dialog
              },
              child: Text('Back'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(reason);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    if (selectedReason != null) {
      // Handle the rejected appointment with the selected reason
      print('Appointment rejected with reason: $selectedReason');
    }
  }
}
