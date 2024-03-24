/// ปัทมาพร ถาเป็นบุญ 640510668
/// login page for login with google account

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:runinmor/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/components/template/white_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, String? selectedRoute});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      body: WhiteContainer(
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
            // Sign in Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF714DA5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    auth.handleGoogleSignin();
                  },
                  icon: SvgPicture.asset(
                    'asset/images/google.svg',
                    width: 30,
                    height: 30,
                  ),
                  label: Text('Sign up with Google'),
                ),
              ),
            ),
            // SignInButton(
            //   Buttons.google,
            //   text: "Sign up with Google",
            //   onPressed: () {},
            //   shape: ,
            // ),
          ],
        ),
      ),
    );
  }
}
