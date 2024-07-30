import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LeafDiagnosisPage extends StatelessWidget {
  const LeafDiagnosisPage({super.key});

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // Do something with the selected image (e.g., display it, upload it, etc.)
      print('Image picked: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaf Diagnosis'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Capture a photo of the leaf',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, size: 50.0),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 50.0),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 50.0),
                  onPressed: () {
                    // Handle refresh
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Take a clear, in-focus photo. Ensure the leaf is centered and no part is cut off.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
