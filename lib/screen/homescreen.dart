import 'package:chatapp/login.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widget/button.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations you have successfully signed in',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            MyButton(
                onTab: () async {
                  await AuthServices().signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
                text: 'Log Out'),
          ],
        ),
      ),
    );
  }
}
