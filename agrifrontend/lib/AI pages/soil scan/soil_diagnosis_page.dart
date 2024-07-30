import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SoilDiagnosisPage extends StatelessWidget {
  const SoilDiagnosisPage({super.key});

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
        title: const Text('Soil Testing'),
        backgroundColor: Colors.orange[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.photo, size: 50.0, color: Colors.orange),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      size: 50.0, color: Colors.orange),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.refresh,
                      size: 50.0, color: Colors.orange),
                  onPressed: () {
                    // Handle refresh
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.orange[100],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Color',
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.orange[100],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Texture',
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.orange[100],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Moisture',
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
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
