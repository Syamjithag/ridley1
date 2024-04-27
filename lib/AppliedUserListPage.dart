import 'package:flutter/material.dart';

class AppliedUserListPage extends StatelessWidget {
  final List<String> appliedUsers;

  AppliedUserListPage({Key? key, required this.appliedUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Users'),
      ),
      body: ListView.builder(
        itemCount: appliedUsers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(appliedUsers[index]),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle user selection
                print('Selected user: ${appliedUsers[index]}');
              },
              child: Text('Select'),
            ),
          );
        },
      ),
    );
  }
}
