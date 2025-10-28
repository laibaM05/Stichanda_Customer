import 'package:flutter/material.dart';
import '../base/bottom_nav_scaffold.dart';
import '../../models/tailor_model.dart';

class ChatPage extends StatefulWidget {
  final Tailor? tailor;
  const ChatPage({super.key, this.tailor});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatSearchController = TextEditingController();

  // Dummy chat threads (previous chats list)
  late final List<_ChatThread> _threads;
  late List<_ChatThread> _filteredThreads;

  // Simple in-memory messages store
  final List<_Message> _messages = [
    _Message(text: 'Hi! How can I help you?', fromTailor: true, time: DateTime.now().subtract(const Duration(minutes: 5))),
    _Message(text: 'I want to stitch a 3-piece suit.', fromTailor: false, time: DateTime.now().subtract(const Duration(minutes: 4))),
    _Message(text: 'Sure! Do you have a preferred style?', fromTailor: true, time: DateTime.now().subtract(const Duration(minutes: 3))),
  ];

  @override
  void initState() {
    super.initState();

    // Seed dummy threads using sample tailors
    final t1 = Tailor(id: '1', name: 'Laiba Majeed', area: 'Federal B Area', category: 'Women');
    final t2 = Tailor(id: '2', name: 'Tooba Fayyaz', area: 'Malir Block 9', category: 'Women, Kids');
    final t3 = Tailor(id: '3', name: 'Talha Hussain', area: 'North Nazimabad', category: 'All');
    final now = DateTime.now();
    _threads = [
      _ChatThread(tailor: t1, lastMessage: 'Order ready by Friday?', time: now.subtract(const Duration(minutes: 12)), unreadCount: 2),
      _ChatThread(tailor: t2, lastMessage: 'Please share your measurements.', time: now.subtract(const Duration(hours: 1, minutes: 5)), unreadCount: 0),
      _ChatThread(tailor: t3, lastMessage: 'Thanks! See you tomorrow.', time: now.subtract(const Duration(days: 1, hours: 3)), unreadCount: 0),
    ];
    _filteredThreads = List.of(_threads);

    _chatSearchController.addListener(_onSearchChanged);

    // Only scroll to bottom if we're viewing a conversation (not the list)
    if (widget.tailor != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomSafe();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _chatSearchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _chatSearchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredThreads = List.of(_threads);
      } else {
        _filteredThreads = _threads.where((t) =>
          t.tailor.name.toLowerCase().contains(q) ||
          t.lastMessage.toLowerCase().contains(q) ||
          t.tailor.area.toLowerCase().contains(q)
        ).toList();
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, fromTailor: false, time: DateTime.now()));
    });
    _textController.clear();

    // Optional: simulate tailor reply
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_Message(text: 'Got it! I\'ll share options shortly.', fromTailor: true, time: DateTime.now()));
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollToBottomSafe();
  }

  void _scrollToBottomSafe() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      try {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        // Silently ignore scroll errors
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inShell = context.findAncestorWidgetOfExactType<BottomNavScaffold>() != null;
    if (!inShell) {
      // If opened directly, show inside the bottom nav shell (Chat tab)
      return const BottomNavScaffold(initialIndex: 0);
    }

    final tailor = widget.tailor;

    // If no tailor passed, show chats inbox list
    if (tailor == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                controller: _chatSearchController,
                decoration: const InputDecoration(
                  hintText: 'Search chats',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredThreads.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final thread = _filteredThreads[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: _Avatar(name: thread.tailor.name),
                    title: Text(
                      thread.tailor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      thread.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(thread.time),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (thread.unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD29356),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              thread.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(tailor: thread.tailor),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Otherwise show conversation view with selected tailor
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _Avatar(name: tailor.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tailor.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    tailor.area,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = !m.fromTailor;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD29356) : const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(m.time),
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _MessageInput(
            controller: _textController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 12,
          top: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000), // Black with 6% opacity
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  prefixIcon: Icon(Icons.message_outlined),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: onSend,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6D7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'T';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _Message {
  final String text;
  final bool fromTailor; // true if message is from tailor, false if from customer
  final DateTime time;
  _Message({required this.text, required this.fromTailor, required this.time});
}

class _ChatThread {
  final Tailor tailor;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;
  _ChatThread({required this.tailor, required this.lastMessage, required this.time, this.unreadCount = 0});
}
