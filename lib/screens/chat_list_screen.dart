import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CHAT MOCK DATA V2 (Added online status) ---
final List<Map<String, dynamic>> mockChats = [
  {
    "isGroup": false,
    "name": "Marta <3",
    "avatarUrl": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "lastMessage": "¡Nos vemos en la cancha a las 8!",
    "time": "18:32",
    "unreadCount": 2,
    "isOnline": true,
  },
  {
    "isGroup": true,
    "name": "Grupo de Pádel",
    "avatarUrl": "https://images.unsplash.com/photo-1544298134-2f085a6e5684?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "lastMessage": "Juan: ¿Alguien para jugar mañana?",
    "time": "17:55",
    "unreadCount": 5,
    "isOnline": false, // Groups can't be online
  },
  {
    "isGroup": false,
    "name": "Coach Griezmann",
    "avatarUrl": "https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "lastMessage": "Perfecto, mañana entrenamos técnica.",
    "time": "Ayer",
    "unreadCount": 0,
    "isOnline": false,
  },
    {
    "isGroup": false,
    "name": "Ana López",
    "avatarUrl": "https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=1961&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "lastMessage": "¡Qué buen partido el de ayer!",
    "time": "Ayer",
    "unreadCount": 0,
    "isOnline": true,
  },
];

// --- CHAT LIST SCREEN V2.1 (Back to Home Button Added) ---
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: mockChats.length,
                itemBuilder: (context, index) {
                  final chat = mockChats[index];
                  return ChatListItemV2(chat: chat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 20, top: 20, bottom: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 24),
            onPressed: () => context.go('/home'),
            tooltip: 'Volver a Inicio',
          ),
          Expanded(
            child: Text(
              'Chats',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, size: 28, color: Colors.black87),
            onPressed: () {},
            tooltip: 'Nuevo Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Buscar conversaciones...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
        ),
      ),
    );
  }
}

// --- CHAT LIST ITEM WIDGET V2 (ELITE DESIGN) ---
class ChatListItemV2 extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatListItemV2({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool hasUnread = chat['unreadCount'] > 0;

    return InkWell(
      onTap: () => context.go('/chats/detail', extra: chat),
      splashColor: const Color(0xFF185a9d).withOpacity(0.1),
      highlightColor: const Color(0xFF185a9d).withOpacity(0.05),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            _buildChatInfo(),
            _buildTimeAndUnread(hasUnread),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(chat['avatarUrl']!),
        ),
        if (chat['isOnline'] == true)
          Positioned(
            bottom: 2, right: 2,
            child: Container(
              width: 12, height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent[400],
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chat['name']!,
            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            chat['lastMessage']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAndUnread(bool hasUnread) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          chat['time']!,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: hasUnread ? const Color(0xFF185a9d) : Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (hasUnread)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF185a9d),
              borderRadius: BorderRadius.circular(12),
               boxShadow: [
                BoxShadow(color: const Color(0xFF185a9d).withOpacity(0.5), blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 4))]
            ),
            child: Text(
              chat['unreadCount'].toString(),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        else
          const SizedBox(height: 22), // Placeholder to keep alignment
      ],
    );
  }
}
