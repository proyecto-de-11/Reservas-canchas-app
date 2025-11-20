import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/user_profile.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:developer' as developer;

class Message {
  final String text;
  final bool isSentByMe;
  final String timestamp;

  Message({required this.text, required this.isSentByMe, required this.timestamp});
}

class ChatScreen extends StatefulWidget {
  final String userId;
  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  Future<UserProfile?>? _userProfileFuture;
  List<Message> _messages = [];
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userProfileFuture == null) {
      _loadChatData();
    }
  }

  Future<void> _loadChatData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;

    if (token == null) {
      if (mounted) {
        setState(() {
          _userProfileFuture = Future.error(Exception("Error de autenticación"));
        });
      }
      return;
    }

    try {
      final profile = await _apiService.getUserProfile(widget.userId);
      
      if (mounted) {
        setState(() {
          _userProfileFuture = Future.value(profile);
        });

        // Simular la carga de mensajes
        await Future.delayed(const Duration(milliseconds: 300));
        final fetchedMessages = [
          Message(text: '¡Hola! ¿Cómo estás?', isSentByMe: false, timestamp: '10:00 AM'),
          Message(text: '¡Hola! Todo bien, ¿y tú?', isSentByMe: true, timestamp: '10:01 AM'),
        ];

        setState(() {
          _messages = fetchedMessages;
          _isLoadingMessages = false;
        });
        _scrollToBottom();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error al cargar el perfil de usuario en ChatScreen',
        name: 'ChatScreen',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _userProfileFuture = Future.error(e);
        });
      }
    }
  }


  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = Message(
      text: _messageController.text.trim(),
      isSentByMe: true,
      timestamp: '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _MessageBubble(message: _messages[index]);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1,
      shadowColor: Colors.grey[200],
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: FutureBuilder<UserProfile?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));
          }
          if (snapshot.hasError) {
            return Text('Error al cargar', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red));
          }
          if (!snapshot.hasData) {
            return Text('Usuario no encontrado', style: GoogleFonts.poppins(fontSize: 16, color: Colors.orange));
          }
          final user = snapshot.data!;
          return Column(
            children: [
              Text(
                user.fullName,
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'En línea',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[600]),
              ),
            ],
          );
        },
      ),
      actions: [
        FutureBuilder<UserProfile?>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
             if (!snapshot.hasData) {
               return const SizedBox(width: 52);
             }
             final user = snapshot.data!;
             final imageUrl = user.profilePictureUrl;
             final hasValidImage = imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: hasValidImage ? NetworkImage(imageUrl) : null,
                 backgroundColor: Colors.grey[200],
                child: !hasValidImage ? const Icon(Icons.person, color: Colors.white) : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              mini: true,
              onPressed: _sendMessage,
              backgroundColor: const Color(0xFF185a9d),
              elevation: 2,
              // **CORRECCIÓN: `child` al final**
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.isSentByMe;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMyMessage ? const Color(0xFF185a9d) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMyMessage ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMyMessage ? const Radius.circular(4) : const Radius.circular(20),
          ),
           boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: GoogleFonts.poppins(
                color: isMyMessage ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.timestamp,
              style: GoogleFonts.poppins(
                color: isMyMessage ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
