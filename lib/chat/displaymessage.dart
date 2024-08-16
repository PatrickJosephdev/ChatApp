import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatefulWidget {
  final String name;
  const DisplayMessage({super.key, required this.name});

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  //instance

  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Message')
      //message is by order of increasing time
      .orderBy('time')
      .snapshots();

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

    return StreamBuilder(
        stream: _messageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              primary: true,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot qds = snapshot.data!.docs[index];
                Timestamp time = qds['time'];
                DateTime dateTime = time.toDate();

                String messengerName = getUserName(qds['name']);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: widget.name == messengerName
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          title: Text(
                            messengerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  qds['message'],
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text("${dateTime.hour}: ${dateTime.minute}")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}
