import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  late File? _imageFile = null;
  final picker = ImagePicker();
  TextEditingController _imageNameController = TextEditingController();

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    // Upload image to Firebase Storage
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    UploadTask uploadTask = storageReference.putFile(_imageFile!);
    await uploadTask.whenComplete(() => null);

    // Get download URL from Firebase Storage
    String imageUrl = await storageReference.getDownloadURL();

    // Store image details in Firestore
    await FirebaseFirestore.instance.collection('images').add({
      'url': imageUrl,
      'name': _imageNameController.text.trim(),
      'uploadedAt': Timestamp.now(),
    });

    // Clear input fields
    _imageNameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageFile == null
                  ? Text('No image selected')
                  : Image.file(
                      _imageFile!,
                      height: 200,
                    ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getImage,
                icon: Icon(Icons.photo_library),
                label: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _imageNameController,
                  decoration: InputDecoration(
                    labelText: 'Image Name',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _imageFile == null ? null : _uploadImage,
                icon: Icon(Icons.cloud_upload),
                label: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}