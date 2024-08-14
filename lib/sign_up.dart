import 'package:chatapp/widget/button.dart';
import 'package:chatapp/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/login.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/screen/homescreen.dart';
import 'package:chatapp/widget/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => const Homescreen(),
    //   ),
    // );

    String west = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);

    // if Signup is success, user has been created and navigate to the next screen
    // otherwise show the error message in the auth.dart file
    if (west == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      setState(() {
        isLoading = true;
      });
      //show a success message
      showSnackBar(context, west);

      //navigate to the next screen
    } else {
      setState(() {
        isLoading = false;
      });
      // show the error message
      showSnackBar(context, west);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.7,
                  child: Image.asset('signup.png'),
                ),
                TextFieldInpute(
                    textEditingController: nameController,
                    hintText: "Enter your name",
                    icon: Icons.person),
                TextFieldInpute(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email),
                TextFieldInpute(
                    textEditingController: passwordController,
                    hintText: "Enter your password",
                    isPass: true,
                    icon: Icons.lock),
                MyButton(onTab: signUpUser, text: 'Sign Up'),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account?   ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
