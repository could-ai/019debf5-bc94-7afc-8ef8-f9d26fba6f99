import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  
  final List<String> _projectTypes = [
    'Mod',
    'Plugin',
    'Datapack',
    'Vlastní Biom'
  ];
  String _selectedProjectType = 'Mod';

  @override
  void initState() {
    super.initState();
    // Úvodní zpráva od AI
    _messages.add(
      ChatMessage(
        text: 'Ahoj! Jsem tvůj AI asistent pro Minecraft. Vyber typ projektu nahoře a napiš mi, co bys chtěl vytvořit (např. nový biom se svítícími houbami nebo modifikaci pro smaragdové brnění).',
        isUser: false,
      )
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    _textController.clear();
    setState(() {
      _messages.insert(
        0, 
        ChatMessage(
          text: text,
          isUser: true,
        )
      );
    });

    // Simulace odpovědi AI
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: 'Pracuji na tvém zadání pro $_selectedProjectType. Připravuji strukturu souborů a kód. Chceš nahrát nějaké vlastní textury přes tlačítko + ?',
              isUser: false,
            )
          );
        });
      }
    });
  }

  void _handleAttachment() {
    // Simulace připojení souboru
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Otevírám správce souborů pro výběr textur, skriptů nebo modelů z PC/mobilu...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minecraft AI Tvořič'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProjectType,
                    icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onPrimaryContainer),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer, 
                      fontWeight: FontWeight.bold
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedProjectType = newValue;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Typ projektu změněn na: $newValue'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    items: _projectTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index], theme);
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(theme),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser)
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.green.shade700,
                child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
              ),
            ),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? theme.colorScheme.primary
                    : theme.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: message.isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: message.isUser ? Radius.zero : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser 
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          
          if (message.isUser)
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Icon(Icons.person, color: theme.colorScheme.onSecondaryContainer, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: theme.colorScheme.onSecondaryContainer,
              onPressed: _handleAttachment,
              tooltip: 'Přidat soubory z PC',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Napiš prompt pro generování...',
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded),
              color: theme.colorScheme.onPrimary,
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}
