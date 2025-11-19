import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CHAT DETAIL MOCK DATA V2 (Added read status) ---
final List<Map<String, dynamic>> mockMessages = [
  {"senderId": "other", "text": "¡Hola! ¿Listo para el partido de hoy?", "time": "18:30"},
  {"senderId": "me", "text": "¡Casi listo! Solo necesito terminar una cosa aquí.", "time": "18:31", "isRead": true},
  {"senderId": "me", "text": "Nos vemos en la cancha a las 8.", "time": "18:31", "isRead": true},
  {"senderId": "other", "text": "¡Perfecto! Allá nos vemos.", "time": "18:32"},
];

// --- CHAT DETAIL SCREEN V2 (ELITE DESIGN) ---
class ChatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8), // Light textured background
      appBar: _buildEliteAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              reverse: true, // Show latest messages at the bottom
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final message = mockMessages[mockMessages.length - 1 - index]; // Display in reverse
                return MessageBubbleV2(message: message);
              },
            ),
          ),
          const MessageInputFieldV2(),
        ],
      ),
    );
  }

  AppBar _buildEliteAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(chat['avatarUrl']!)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(chat['name']!, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            if (chat['isOnline'] == true)
              Text('En línea', style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[600])),
          ]),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black54, size: 28), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.black54, size: 28), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }
}

// --- MESSAGE BUBBLE WIDGET V2 (ELITE DESIGN) ---
class MessageBubbleV2 extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageBubbleV2({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isMe = message['senderId'] == 'me';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: isMe ? const LinearGradient(colors: [Color(0xFF185a9d), Color(0xFF43cea2)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
          color: isMe ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22), topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(isMe ? 22 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 22),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: GoogleFonts.poppins(fontSize: 15, color: isMe ? Colors.white : Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message['time'],
                  style: GoogleFonts.poppins(fontSize: 11, color: isMe ? Colors.white70 : Colors.grey[500]),
                ),
                if (isMe) ...[const SizedBox(width: 8), Icon(Icons.done_all, size: 16, color: message['isRead'] == true ? Colors.lightBlueAccent : Colors.white70)],
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- MESSAGE INPUT FIELD WIDGET V2 (ELITE DESIGN) ---
class MessageInputFieldV2 extends StatefulWidget {
  const MessageInputFieldV2({super.key});
  @override
  State<MessageInputFieldV2> createState() => _MessageInputFieldV2State();
}

class _MessageInputFieldV2State extends State<MessageInputFieldV2> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _canSend = _controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))]
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600]), onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _controller,
                style: GoogleFonts.poppins(fontSize: 15),
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12)
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.attach_file_rounded, color: Colors.grey[600]), onPressed: () {}),
            const SizedBox(width: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _canSend ? const LinearGradient(colors: [Color(0xFF185a9d), Color(0xFF43cea2)]) : null,
                color: _canSend ? null : Colors.grey[300],
                boxShadow: _canSend ? [BoxShadow(color: const Color(0xFF185a9d).withOpacity(0.6), blurRadius: 10, spreadRadius: -2)] : [],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _canSend ? () { /* TODO: Send message */ } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
