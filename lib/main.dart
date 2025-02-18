import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() {
  runApp(RTSPStreamingApp());
}

class RTSPStreamingApp extends StatelessWidget {
  const RTSPStreamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RTSPStreamScreen(),
    );
  }
}

class RTSPStreamScreen extends StatefulWidget {
  const RTSPStreamScreen({super.key});

  @override
  _RTSPStreamScreenState createState() => _RTSPStreamScreenState();
}

class _RTSPStreamScreenState extends State<RTSPStreamScreen> {
  final TextEditingController _urlController = TextEditingController();
  VlcPlayerController? _vlcController;
  String rtspUrl = "";

  void _startStreaming() {
    if (rtspUrl.isNotEmpty) {
      try {
        setState(() {
          _vlcController = VlcPlayerController.network(
            rtspUrl,
            autoPlay: true,
            options: VlcPlayerOptions(),
          );
        });
      } catch (e) {
        print("Error starting RTSP stream: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to start stream. Check the URL.")),
        );
      }
    }
  }

  void _pauseStream() {
    _vlcController?.pause();
  }

  void _stopStream() {
    _vlcController?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RTSP Video Streaming")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Enter RTSP URL",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                rtspUrl = value;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _startStreaming, child: Text("Play")),
                ElevatedButton(onPressed: _pauseStream, child: Text("Pause")),
                ElevatedButton(onPressed: _stopStream, child: Text("Stop")),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _vlcController != null
                  ? VlcPlayer(
                      controller: _vlcController!,
                      aspectRatio: 16 / 9,
                      placeholder: Center(child: CircularProgressIndicator()),
                    )
                  : Center(child: Text("Enter an RTSP URL to start streaming")),
            ),
          ],
        ),
      ),
    );
  }
}
