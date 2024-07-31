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
        title: const Text(
          'Soil Testing',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      const Icon(Icons.photo, size: 50.0, color: Colors.green),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      size: 50.0, color: Colors.green),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 30.0),
                IconButton(
                  icon: const Icon(Icons.refresh,
                      size: 50.0, color: Colors.green),
                  onPressed: () {
                    // Handle refresh
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildInputField(label: 'Color', hintText: 'Select soil color'),
            _buildInputField(label: 'Texture', hintText: 'Select soil texture'),
            _buildInputField(
                label: 'Moisture', hintText: 'Select soil moisture level'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hintText}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.green[100],
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hintText,
          suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.green),
        ),
      ),
    );
  }
}
