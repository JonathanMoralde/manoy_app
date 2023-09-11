import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatefulWidget {
  final bool showApprovalDialog;
  final bool showApprovedRejectedText;
  final Future<List<Map<String, dynamic>>> Function() filteringFunction;

  const PostCard({
    Key? key,
    this.showApprovalDialog = true,
    this.showApprovedRejectedText = true,
    required this.filteringFunction,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

Future<List<Map<String, dynamic>>> fetchFilteredPosts() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('posts').get();

  List<Map<String, dynamic>> posts =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  final filteredPosts = posts.where((postData) {
    Timestamp timestamp = postData['timestamp'];
    DateTime postTime = timestamp.toDate();
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(postTime);

    // Filter out posts that are older than 24 hours or have 'Rejected' status
    return difference.inHours <= 24 && postData['status'] == 'Approved';
  }).toList();

  return filteredPosts;
}

Future<List<Map<String, dynamic>>> fetchAllPostCards() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('posts').get();

  List<Map<String, dynamic>> posts =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  final allPosts = posts.where((postData) {
    Timestamp timestamp = postData['timestamp'];
    DateTime postTime = timestamp.toDate();
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(postTime);
    return difference.inHours <= 24;
    //  &&
    //     postData['status'] == 'Approved'; // Filter by status 'Approved'
  }).toList();

  return allPosts;
}

class _PostCardState extends State<PostCard> {
  Stream<int> timerStream() {
    return Stream.periodic(Duration(minutes: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<int>(
          stream: timerStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Text(
                'Last updated: ${DateTime.now().toString()}',
                style: TextStyle(fontSize: 16),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: widget.filteringFunction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No recent posts available.');
            } else {
              return Column(
                children: snapshot.data!.map((postData) {
                  String status = postData['status'] ?? 'Pending';

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.showApprovalDialog) {
                            // Show a confirmation dialog only if showApprovalDialog is true
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Post Approval'),
                                  content: Text(
                                      'Do you wish to approve or reject this post?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Approve'),
                                      onPressed: () async {
                                        // Handle approval logic here
                                        String userId = postData[
                                            'userId']; // Replace with your field name
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(
                                                userId) // Use the user's ID as the document ID
                                            .update({'status': 'Approved'});
                                        setState(() {
                                          // Update the status variable to reflect the new status
                                          status = 'Approved';
                                        });
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Reject'),
                                      onPressed: () async {
                                        // Handle rejection logic here
                                        String userId = postData[
                                            'userId']; // Replace with your field name
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(
                                                userId) // Use the user's ID as the document ID
                                            .update({'status': 'Rejected'});
                                        setState(() {
                                          // Update the status variable to reflect the new status
                                          status = 'Rejected';
                                        });
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade200),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        postData['service_photo'],
                                        width: 55,
                                        height: 55,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          postData['service_name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          formatTimeAgo(postData['timestamp']),
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Text(postData['caption'])),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: CachedNetworkImage(
                                    imageUrl: postData['imageUrl']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.showApprovedRejectedText ? status : '',
                                  style: TextStyle(
                                    color: status == 'Approved'
                                        ? Colors.green
                                        : (status == 'Rejected'
                                            ? Colors.red
                                            : Colors.orange),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  String formatTimeAgo(Timestamp timestamp) {
    DateTime postTime = timestamp.toDate();
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else {
      int hours = difference.inHours;
      if (hours < 24) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else {
        int days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      }
    }
  }
}
