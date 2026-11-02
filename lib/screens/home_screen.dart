import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';
import '../widgets/blob_widget.dart';
import '../widgets/mic_button.dart';
import '../services/local_storage.dart';
import 'subscription_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isListening = false;
  bool isSpeaking = false;
  bool showCC = false;
  List<Map<String, dynamic>> messages = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadMessages();
  }

  Future<void> _loadUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() => userEmail = user.email);
    } else {
      final res = await supabase.auth.signInAnonymously();
      setState(() => userEmail = res.user?.email);
    }
  }

  Future<void> _loadMessages() async {
    final history = await LocalStorage.getHistory();
    setState(() => messages = history);
  }

  void _handleLongPressStart() {
    setState(() => isListening = true);
  }

  void _handleLongPressEnd() {
    setState(() {
      isListening = false;
      isSpeaking = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => isSpeaking = false);
    });
  }

  void _handleSendText() {
    if (_textController.text.trim().isEmpty) return;
    String text = _textController.text.trim();
    LocalStorage.saveMessage('user', text);
    setState(() {
      messages.add({'role': 'user', 'text': text});
    });
    _textController.clear();
    setState(() => isSpeaking = true);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        String aiReply = "HAHAHA you porcupine! You said: $text";
        LocalStorage.saveMessage('ai', aiReply);
        setState(() {
          messages.add({'role': 'ai', 'text': aiReply});
          isSpeaking = false;
        });
      }
    });
  }

  void _shareConversation() {
    String fullChat = messages.map((m) => "${m['role']}: ${m['text']}").join("\n");
    if (fullChat.isNotEmpty) {
      Share.share(fullChat, subject: 'My chat with Solo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF8B5CF6),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    SizedBox(height: 12),
                    Text(userEmail ?? 'Guest User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Free Plan', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.workspace_premium),
                title: Text('Subscription'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Clear History'),
                onTap: () async {
                  await LocalStorage.clear();
                  setState(() => messages = []);
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('Solo v1.0 • Made with 💜', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.notes, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: _shareConversation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlobWidget(isListening: isListening, isSpeaking: isSpeaking, audioLevel: 0.5),
                SizedBox(height: 30),
                if (isListening) Waveform(),
                if (isListening) SizedBox(height: 10),
                if (isListening) Text('Listening...', style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w600)),
                if (isSpeaking) Text('Solo is speaking...', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 20),
                if (messages.isNotEmpty && showCC)
                  Container(
                    height: 120,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFE5E7EB)),
                    ),
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final m = messages[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text("${m['role']}: ${m['text']}", style: TextStyle(fontSize: 13, color: m['role'] == 'user' ? Colors.black : Color(0xFF8B5CF6))),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => showCC = !showCC),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: showCC ? Color(0xFF8B5CF6) : Colors.white,
                      border: Border.all(color: Color(0xFFE5E7EB)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.closed_caption, color: showCC ? Colors.white : Colors.black54),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Type if Solo can\'t hear...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, size: 20),
                          onPressed: _handleSendText,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                isSpeaking
                    ? GestureDetector(
                        onTap: () => setState(() => isSpeaking = false),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      )
                    : MicButton(
                        isListening: isListening,
                        isSpeaking: isSpeaking,
                        onLongPressStart: _handleLongPressStart,
                        onLongPressEnd: _handleLongPressEnd,
                        onStopSpeaking: () => setState(() => isSpeaking = false),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
