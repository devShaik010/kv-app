import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kisanverse/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AiBotScreen extends StatefulWidget {
  const AiBotScreen({super.key});

  @override
  State<AiBotScreen> createState() => _AiBotScreenState();
}

class _AiBotScreenState extends State<AiBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  
  bool _isListening = false;
  bool _isLoading = false;
  bool _isPlaying = false;
  bool _speechAvailable = false;
  String? _currentPlayingAudio;
  
  static const String _farmerAssistantUrl = 'http://192.168.137.58:5000/farmer_assistant';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // Add welcome message
    _messages.add({
      'role': 'assistant',
      'content': 'Hello! I\'m your AI farming assistant. Ask me anything about farming, crops, or agriculture. You can type or use voice input!',
      'timestamp': DateTime.now(),
    });
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        print('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print('Speech error: $error');
        setState(() => _isListening = false);
      },
    );
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _speech.stop();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition not available on this device'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() => _isListening = true);

      await _speech.listen(
        onResult: (result) {
          setState(() {
            if (result.finalResult) {
              _isListening = false;
              // Send the recognized text to farmer assistant
              if (result.recognizedWords.isNotEmpty) {
                _sendMessage(result.recognizedWords);
              }
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: false,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } catch (e) {
      print('Error starting listening: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting voice input: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isListening = false);
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'role': 'user',
        'content': text.trim(),
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    // Clear text field and scroll
    _textController.clear();
    _scrollToBottom();

    try {
      // Call farmer assistant API with POST method
      final response = await http.post(
        Uri.parse(_farmerAssistantUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'text': text.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': data['answer'] ?? 'No response received',
            'question': data['question'],
            'language_code': data['language_code'],
            'voice_model': data['voice_model'],
            'audio_data': data['audio_data'],
            'timestamp': DateTime.now(),
          });
        });

        _scrollToBottom();
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      // Add error message
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Sorry, I encountered an error. Please try again.',
          'timestamp': DateTime.now(),
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playAudioResponse(String base64Audio, String messageId) async {
    try {
      // Stop if already playing this audio
      if (_currentPlayingAudio == messageId && _isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentPlayingAudio = null;
        });
        return;
      }

      // Decode base64 audio
      final audioBytes = base64Decode(base64Audio);
      
      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final audioFile = File('${directory.path}/response_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await audioFile.writeAsBytes(audioBytes);

      // Play audio
      setState(() {
        _isPlaying = true;
        _currentPlayingAudio = messageId;
      });

      await _audioPlayer.play(DeviceFileSource(audioFile.path));
      
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _currentPlayingAudio = null;
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isPlaying = false;
        _currentPlayingAudio = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(l10n.aiBot),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to use'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Type your question in the text field'),
                      SizedBox(height: 8),
                      Text('• Or press and hold the 🎤 button to record your voice'),
                      SizedBox(height: 8),
                      Text('• Release the button when done speaking'),
                      SizedBox(height: 8),
                      Text('• Tap the play button to hear the audio response'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                final messageId = '${message['timestamp']}';
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF4CAF50)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'],
                          style: TextStyle(
                            fontSize: 15,
                            color: isUser ? Colors.white : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        if (!isUser && message['audio_data'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: InkWell(
                              onTap: () => _playAudioResponse(message['audio_data'], messageId),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      (_isPlaying && _currentPlayingAudio == messageId)
                                          ? Icons.stop_circle
                                          : Icons.play_circle,
                                      color: const Color(0xFF4CAF50),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      (_isPlaying && _currentPlayingAudio == messageId)
                                          ? 'Stop'
                                          : 'Play audio',
                                      style: const TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Loading Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isListening ? 'Listening...' : 'Thinking...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Voice Input Button
                  GestureDetector(
                    onTap: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.red
                            : const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Send Button
                  GestureDetector(
                    onTap: () => _sendMessage(_textController.text),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
