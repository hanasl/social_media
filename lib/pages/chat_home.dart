import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatScreen.dart';

class chatScreenHome extends StatefulWidget {
  const chatScreenHome({super.key});

  @override
  State<chatScreenHome> createState() => _chatScreenHomeState();
}

class _chatScreenHomeState extends State<chatScreenHome> {
  @override
  Widget build(BuildContext context) {
    final User? userr = FirebaseAuth.instance.currentUser;
    final _uid = userr!.uid;
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('utlisateur')
          .doc(_uid)
          .collection('messages')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
         // if (snapshot.data.docs.length < 1) {
            //return Center(
             // child: Text(
               // 'No Chats Yet',
              // style: GoogleFonts.montserrat(fontSize: 16),
             // ),
          //  );
        //  }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var U_id = snapshot.data.docs[index].id;
              var lastMsg = snapshot.data.docs[index]['last_msg'];
              return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(U_id)
                      .get(),
                  builder: (context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      var client = asyncSnapshot.data;
                      return ListTile(
                        title: Text(
                          client['fullname'],
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Container(
                          child: Text(
                            "${lastMsg}",
                            style: TextStyle(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => chatScreen(
                                        id: client["id"],
                                        name: client["fullname"],
                                        

                                        //  c_pic: transporter['image']
                                      )));
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    }
                  });
            },
          );
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.green,
        ));
      },
    ));
  }
}