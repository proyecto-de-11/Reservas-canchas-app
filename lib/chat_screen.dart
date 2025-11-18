import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Data Models ---
class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

// --- Screen ---
class ChatScreen extends StatefulWidget {
  final String otherUserName;

  const ChatScreen({super.key, required this.otherUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(text: '¡Hola! ¿Todo bien para el partido de mañana?', date: DateTime.now().subtract(const Duration(minutes: 5)), isSentByMe: false),
    Message(text: '¡Claro! Todo listo. ¿Llevas el balón?', date: DateTime.now().subtract(const Duration(minutes: 4)), isSentByMe: true),
    Message(text: 'Sí, yo me encargo. No te preocupes.', date: DateTime.now().subtract(const Duration(minutes: 3)), isSentByMe: true),
    Message(text: 'Perfecto, entonces nos vemos en la cancha a las 8.', date: DateTime.now().subtract(const Duration(minutes: 2)), isSentByMe: false),
    Message(text: '¡Hecho! Allá nos vemos.', date: DateTime.now().subtract(const Duration(minutes: 1)), isSentByMe: true),
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Para que los mensajes más nuevos estén abajo
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const CircleAvatar(
            // Reemplazar con la imagen del usuario
            backgroundImage: NetworkImage('https://picsum.photos/seed/user-chat/200'),
          ),
          const SizedBox(width: 12),
          Text(
            widget.otherUserName,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0056B3),
      foregroundColor: Colors.white,
      elevation: 4,
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMyMessage = message.isSentByMe;
    final alignment = isMyMessage ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isMyMessage ? const Color(0xFF007BFF) : Colors.grey[200];
    final textColor = isMyMessage ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMyMessage ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMyMessage ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]
        ),
        child: Text(
          message.text,
          style: GoogleFonts.poppins(fontSize: 15, color: textColor),
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                // Lógica para enviar mensaje
              },
              color: const Color(0xFF007BFF),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }
}
