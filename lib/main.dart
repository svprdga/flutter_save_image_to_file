import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save image to disk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  static const _url =
      'https://upload.wikimedia.org/wikipedia/en/8/86/Einstein_tongue.jpg';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save image to disk'),
        actions: [
// [...]
IconButton(
  // Call the method we just created
  onPressed: () => _saveImage(context),
  icon: const Icon(Icons.save),
),
// [...]
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.network(_url),
          ),
        ),
      ),
    );
  }

Future<void> _saveImage(BuildContext context) async {
  String? message;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // Download image
    final http.Response response = await http.get(Uri.parse(_url));

    // Get temporary directory
    final dir = await getTemporaryDirectory();

    // Create an image name
    var filename = '${dir.path}/image.png';

    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);

    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      message = 'Image saved to disk';
    }
  } catch (e) {
    message = 'An error occurred while saving the image';
  }

  if (message != null) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
}
