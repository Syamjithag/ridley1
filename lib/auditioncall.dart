import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('images').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
              return ImageListItem(
                imageUrl: data?['url'],
                imageName: data?['name'], key: null,
                documentId: document.id,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ImageListItem extends StatelessWidget {
  final String imageUrl;
  final String imageName;
  final String documentId;

  const ImageListItem({
    Key? key,
    required this.imageUrl,
    required this.imageName,
    required this.documentId,
  }) : super(key: key);

  Future<void> _applyImage() async {
    try {
      // Get current user
      // User user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   throw Exception('User not logged in');
      // }

      // Update Firestore document to add user ID to applied users array
      await FirebaseFirestore.instance.collection('images').doc(documentId).update({
        'appliedUsers': FieldValue.arrayUnion(['5ImvqV1hc80sRxFbyzZ2']),
      });

      print('User ${'5ImvqV1hc80sRxFbyzZ2'} applied to image $documentId');
    } catch (error) {
      print('Error applying to image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            imageName ?? 'Unnamed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _applyImage,
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}

