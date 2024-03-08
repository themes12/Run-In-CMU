import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/user_provider.dart';

import '../components/template/white_container.dart';
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
      backgroundColor: const Color(0xFF714DA5),
      body: WhiteContainer(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RunNaiMor',
                  style: TextStyle(
                    color: Color(0xFF714DA5),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'asset/images/run.png',
                    width: 350,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30), // Spacing
                // Welcome Text
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20), // Adjust values as needed
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome,',
                      style: TextStyle(
                        color: Color(0xFF714DA5),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20), // Adjust values as needed
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ready to run?',
                      style: TextStyle(
                        color: Color(0xFFA6A6A6),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF714DA5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await user.setUsername(myController.text);
                          if (context.mounted) context.goNamed('Home');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       children: [
    //         Text("Setup user page"),
    //         ElevatedButton(
    //           onPressed: () {
    //             _auth.signOut();
    //           },
    //           child: Text("Sign out"),
    //         ),
    //         TextField(
    //           controller: myController,
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             try {
    //               await user.setUsername(myController.text);
    //               if (context.mounted) context.goNamed('Home');
    //             } catch (e) {
    //               print(e);
    //             }
    //           },
    //           child: Text("Submit"),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
