import 'package:flutter/foundation.dart';
import 'package:flutter_application_4_geodesica/model/user_message_model.dart';


class ChatProvider with ChangeNotifier {
  List<UserMessageModel> _messages = [];

  List<UserMessageModel> get messages => _messages;

  void addMessage(UserMessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  // Opcional: cargar mensajes iniciales
  void loadInitialMessages() {
    _messages = [
      UserMessageModel(
        rol: 'system',
        message: '¡Hola! ¿En qué puedo ayudarte hoy?',
        id: 1,
      ),
    ];
    notifyListeners();
  }
}