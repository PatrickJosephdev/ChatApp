import 'package:chatapp/chat/displaymessage.dart';
import 'package:chatapp/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatapp/services/auth.dart';

class ChatPage extends StatefulWidget {
  final String? email;

  const ChatPage({super.key, required this.email});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // for controller

  final TextEditingController messageController = TextEditingController();
  //for firebase instance

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String getUserName(String email) {
      if (email.isEmpty) {
        return ""; // Handle empty email case (optional)
      }
      int indexOfAt = email.indexOf('@');
      if (indexOfAt == -1) {
        return email; // No "@" symbol found, return entire email
      }
      return email.substring(0, indexOfAt); // Extract username before "@"
    }

    String name = getUserName(widget.email!);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
        actions: [
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.blue,
            onPressed: () async {
              AuthServices().signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: DisplayMessage(
                  name: name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Message',
                        enabled: true,
                        contentPadding:
                            const EdgeInsets.only(left: 15, bottom: 8, top: 8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        messageController.text = value!;
                      },
                    )),
                    IconButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            firebaseFirestore.collection('Message').doc().set({
                              'message': messageController.text.trim(),
                              'time': DateTime.now(),
                              'name': widget.email,
                            });
                            messageController
                                .clear(); //to clear the text after send
                          }
                        },
                        icon: const Icon(
                          Icons.send_sharp,
                          size: 30,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
