import 'package:chatapp/chat/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCv270NdLn1u7dwFwQwLtiRAwSQXvgoFoI",
            authDomain: "chatapp-ee127.firebaseapp.com",
            projectId: "chatapp-ee127",
            storageBucket: "chatapp-ee127.appspot.com",
            messagingSenderId: "682964942617",
            appId: "1:682964942617:web:e593630ddda5b4735e8f88",
            measurementId: "G-H40K9S6SGB"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data! as User;
              return ChatPage(
                email: user.email,
              );
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
