import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isRecording = false;
  late AudioRecorder _audioRecorder;
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _filePath = ''; // Initialize with an empty path
  }

  Future<void> startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final path = appDocDir.path + '/myFile.m4a';

      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() {
        isRecording = true;
        _filePath = path;
      });
      print("Recording started. File path: $_filePath");
      Fluttertoast.showToast(
        msg: "Recording started. File path: $_filePath",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // Handle permissions not granted
      print("Permissions not granted");
    }
  }

  Future<void> stopRecording() async {
    await _audioRecorder.stop();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    setState(() {
      isRecording = false;
      _filePath = '';
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecording)
              ElevatedButton(
                onPressed: () {
                  stopRecording();
                },
                child: Text("Stop Recording"),
              )
            else
              ElevatedButton(
                onPressed: () {
                  startRecording();
                },
                child: Text("Start Recording"),
              ),
            SizedBox(height: 16),
            if (!isRecording && _filePath.isNotEmpty)
              ElevatedButton(
                onPressed: cancelRecording,
                child: Text("Cancel Recording"),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatPage(),
  ));
}
