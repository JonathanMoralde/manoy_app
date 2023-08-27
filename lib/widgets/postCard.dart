import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  Stream<int> timerStream() {
    return Stream.periodic(Duration(minutes: 1), (i) => i);
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
      return difference.inHours <= 24;
    }).toList();

    return filteredPosts;
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
          future: fetchFilteredPosts(),
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
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.network(
                                postData['service_photo'],
                                width: 75,
                                height: 75,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postData['service_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(postData['caption']),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(postData['imageUrl']),
                        ),
                      ],
                    ),
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
