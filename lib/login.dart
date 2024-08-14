import 'package:chatapp/screen/homescreen.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widget/textfield.dart';
import 'package:chatapp/widget/button.dart';
import 'package:chatapp/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    String west = await AuthServices().loginUser(
        email: emailController.text, password: passwordController.text);

    // if Login is success, user has been created and navigate to the next screen
    // otherwise show the error message in the auth.dart file
    if (west == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Homescreen(),
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
                  child: Image.asset('login.png'),
                ),
                TextFieldInpute(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email),
                TextFieldInpute(
                    textEditingController: passwordController,
                    isPass: true,
                    hintText: "Enter your password",
                    icon: Icons.lock),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                MyButton(onTab: loginUsers, text: 'Log In'),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont't have an Account?   ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'SignUp',
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
