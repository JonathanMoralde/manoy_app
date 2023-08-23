import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MessageInbox extends ConsumerWidget {
      


  const MessageInbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
          final uid = ref.watch(uidProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages/Inbox"),
      ),
    );
  }
}
