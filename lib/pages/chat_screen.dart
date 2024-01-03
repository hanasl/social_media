import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users"),
     backgroundColor: 
        Theme.of(context).colorScheme.inversePrimary,
        elevation: 0, 
        ),
         body: _buildUserList(),
    );
  }
      //list of users
    Widget _buildUserList(){
      return StreamBuilder <QuerySnapshot > 
      (stream: FirebaseFirestore.instance.collection('utilisateur').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('loading...');
        }
        return ListView(
        children: snapshot.data!.docs.map<Widget>(
          (doc)=>_buildUserListItem(doc)).toList(),
        );
      },);
    }
    //individual user list item
 Widget _buildUserListItem(DocumentSnapshot document){
Map<String, dynamic> data= document.data()! as Map<String,dynamic>;
  //display all users
 if (_auth.currentUser!.email != data['Email']){
  return ListTile(
    title:Text( data ['fullname']),
    onTap: (){
      //pass the clicked user to the chat app
      Navigator.push
      (context, MaterialPageRoute(builder: 
      (context)=>ChatSreen(
        receiverUserName: data['fullname'],
        receiverUserID:data ['id'] ,
      ),
      ),
      );
    },
  );
 }else{
  //empty container
  return Container();
 }
  }
  }
