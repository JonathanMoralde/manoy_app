import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/message_bottomNav.dart';

class MessagePage extends ConsumerWidget {
  final String name;
  final String shopId;


  const MessagePage({Key? key, required this.name, required this.shopId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final uid = ref.watch(uidProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(name), 
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Your chat message content here
              color: Colors.white, // Set your preferred background color
            ),
          ),
          const MessageBottomAppBar(),
        ],
      ),
    );
  }
}
