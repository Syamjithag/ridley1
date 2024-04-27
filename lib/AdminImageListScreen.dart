import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridley/AppliedUserListPage.dart';

class AdminImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Image List'),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;
              return AdminImageListItem(
                imageUrl: data?['url'],
                imageName: data?['name'],
                appliedUsers: List<String>.from(data?['appliedUsers'] ?? []),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class AdminImageListItem extends StatelessWidget {
  final String imageUrl;
  final String imageName;
  final List<String> appliedUsers;

  const AdminImageListItem({
    Key? key,
    required this.imageUrl,
    required this.imageName,
    required this.appliedUsers,
  }) : super(key: key);

  Future<void> _viewAppliedUsers(BuildContext context) async {
    try {
      // Get user details for applied users
      List<String> appliedUserNames = [];
      for (String userId in appliedUsers) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          String username = userSnapshot.get('firstname');
          appliedUserNames.add(username);
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AppliedUserListPage(appliedUsers: appliedUserNames),
        ),
      );
    } catch (error) {
      print('Error viewing applied users: $error');
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _viewAppliedUsers(context),
            child: const Text('View Applied List'),
          ),
        ],
      ),
    );
  }
}
