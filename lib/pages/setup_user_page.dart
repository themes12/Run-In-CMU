import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/user_provider.dart';

import '../provider/auth_provider.dart';

class SetupUserPage extends StatefulWidget {
  const SetupUserPage({super.key});

  @override
  State<SetupUserPage> createState() => _SetupUserPageState();
}

class _SetupUserPageState extends State<SetupUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Setup user page"),
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
              },
              child: Text("Sign out"),
            ),
            TextField(
              controller: myController,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await user.setUsername(myController.text);
                  if (context.mounted) context.goNamed('Home');
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
