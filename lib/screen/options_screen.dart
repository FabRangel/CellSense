import 'package:cellsense/screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(image: _image!),
        ),
      );
    }
  }
  Future<void> _selectFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(image: _image!),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cell Sense")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
           onPressed: _takePicture,
          icon: const Icon(Icons.camera),
          label: const Text("Tomar Fotografía"),
        ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _selectFromGallery,
              icon: const Icon(Icons.photo),
              label: const Text("Seleccionar de Galería"),
            ),
          ],
        ),
      ),
    );
  }
}