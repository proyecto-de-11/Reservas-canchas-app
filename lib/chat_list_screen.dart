import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Data Model ---
class ChatPreview {
  final String userId;
  final String userName;
  final String lastMessage;
  final String timestamp;
  final String avatarUrl;
  final int unreadCount;

  ChatPreview({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.timestamp,
    required this.avatarUrl,
    this.unreadCount = 0,
  });
}

// --- Screen ---
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatPreview> _chatPreviews = [
    ChatPreview(
      userId: '1',
      userName: 'Juan Pérez',
      lastMessage: '¡Hecho! Allá nos vemos.',
      timestamp: '10:45 AM',
      avatarUrl: 'https://picsum.photos/seed/juan/200',
      unreadCount: 2,
    ),
    ChatPreview(
      userId: '2',
      userName: 'Equipo de Fútbol',
      lastMessage: 'Recuerden llevar la equipación azul.',
      timestamp: 'Ayer',
      avatarUrl: 'https://picsum.photos/seed/equipo/200',
    ),
    ChatPreview(
      userId: '3',
      userName: 'Ana García',
      lastMessage: '¿Te apuntas al torneo del sábado?',
      timestamp: 'Ayer',
      avatarUrl: 'https://picsum.photos/seed/ana/200',
    ),
     ChatPreview(
      userId: '4',
      userName: 'Carlos López',
      lastMessage: '¡Qué gran partido el de ayer!',
      timestamp: '2d atrás',
      avatarUrl: 'https://picsum.photos/seed/carlos/200',
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _chatPreviews.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = _chatPreviews[index];
          return _buildChatListItem(chat);
        },
      ),
    );
  }

  Widget _buildChatListItem(ChatPreview chat) {
    return InkWell(
      onTap: () {
        context.go('/home/chats/${chat.userId}', extra: {'userName': chat.userName});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.userName,
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chat.lastMessage,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.timestamp,
                  style: GoogleFonts.poppins(fontSize: 12, color: chat.unreadCount > 0 ? const Color(0xFF007BFF) : Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF007BFF),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
