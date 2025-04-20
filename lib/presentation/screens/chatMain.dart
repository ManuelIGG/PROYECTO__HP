import 'package:flutter/material.dart';
import 'package:flutter_application_4_geodesica/presentation/providers/messageProvider.dart';
import 'package:flutter_application_4_geodesica/presentation/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4_geodesica/model/user_message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadInitialMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = UserMessageModel(
      rol: 'user',
      message: _messageController.text,
      id: DateTime.now().millisecondsSinceEpoch,
    );

    Provider.of<ChatProvider>(context, listen: false).addMessage(newMessage);
    _messageController.clear();

    Future.delayed(const Duration(seconds: 1), () {
      final responseMessage = UserMessageModel(
        rol: 'system',
        message: 'Gracias por tu mensaje. Estoy procesando tu solicitud.',
        id: DateTime.now().millisecondsSinceEpoch + 1,
      );
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).addMessage(responseMessage);
    });
  }

  void _logout() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Básico'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'theme',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tema'),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Claro'),
                            selected: !themeProvider.isDarkMode,
                            onSelected: (selected) {
                              if (selected) {
                                themeProvider.setThemeMode(false);
                              }
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Oscuro'),
                            selected: themeProvider.isDarkMode,
                            onSelected: (selected) {
                              if (selected) {
                                themeProvider.setThemeMode(true);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'fontSize',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tamaño de letra'),
                      Slider(
                        value: themeProvider.fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 4,
                        label: themeProvider.fontSize.round().toString(),
                        onChanged: (value) {
                          themeProvider.setFontSize(value);
                        },
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: _buildMessagesList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessagesList() {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: true);

    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          reverse: false,
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final message = provider.messages[index];
            return _buildMessageBubble(message, themeProvider.fontSize);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(UserMessageModel message, double fontSize) {
    final isUserMessage = message.rol == 'user';
    final theme = Theme.of(context);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isUserMessage
                  ? theme.primaryColor
                  : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : theme.colorScheme.onSurface,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(fontSize: themeProvider.fontSize),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }
}
