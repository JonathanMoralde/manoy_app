import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';

class UserAppointmentsPage extends StatefulWidget {
  final String name;
  final String userId;
  const UserAppointmentsPage(
      {Key? key, required this.name, required this.userId})
      : super(key: key);

  @override
  State<UserAppointmentsPage> createState() => _UserAppointmentsPageState();
}

class _UserAppointmentsPageState extends State<UserAppointmentsPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('APPOINTMENTS'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('userId', isEqualTo: userId)
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
                    final status = appointmentData['status'] as String;
                    final shopName = appointmentData['shopName'] as String;

                    final DateTime dateTime = date.toDate();
                    final year = dateTime.year;
                    final month = dateTime.month;
                    final day = dateTime.day;

                    final formattedDate = '$year-$month-$day';

                    return GestureDetector(
                      onTap: () {
                        _showConfirmationDialog(
                            context, appointment.id, status);
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
                            Text('Shop: $shopName',
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                            Text('Date: $formattedDate'),
                            Text('Email: $email'),
                            Text('Time: $time'),
                            Row(
                              children: [
                                Text('Status: '),
                                Text(
                                  '$status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
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

  Future<void> _showConfirmationDialog(
      BuildContext context, String docId, String status) async {
    bool? isConfirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('CANCEL APPOINTMENT'),
          content: Text('Do you want to cancel the appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                // Update the docId with the status as "Cancelled"
                updateAppointmentStatus(docId, "Cancelled");
                Navigator.of(context).pop(true);
              },
              child: Text('Cancel Appointment'),
            ),
            TextButton(
              onPressed: () {
                updateAppointmentStatus(docId, "Pending");
                Navigator.of(context).pop(false);
              },
              child: Text('Keep Appointment'),
            ),
          ],
        );
      },
    );
    if (isConfirmed != null && !isConfirmed) {
      // Handle the case when the user cancels the cancellation
    }
  }

  void updateAppointmentStatus(String docId, String status) {
    try {
      FirebaseFirestore.instance.collection('appointments').doc(docId).update({
        'status': status,
      });
      print('Appointment status updated to: $status');
    } catch (error) {
      print('Error updating appointment status: $error');
    }
  }
}
