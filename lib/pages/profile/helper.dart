// helpers.dart

String _generateChatRoomId(String userId1, String userId2) {
  final List<String> ids = [userId1, userId2];
  ids.sort();
  return ids.join('_');
}
