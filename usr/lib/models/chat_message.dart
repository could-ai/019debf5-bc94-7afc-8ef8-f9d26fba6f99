class ChatMessage {
  final String text;
  final bool isUser;
  final List<String> attachedFiles;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.attachedFiles = const [],
  });
}
