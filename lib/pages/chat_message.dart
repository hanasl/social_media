import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../components/chat_buble.dart';
import '../services/chat_service.dart';

class ChatSreen extends StatefulWidget {
   final String receiverUserName;
  final String receiverUserID;
  const ChatSreen({
    super.key,
  required this.receiverUserName,
  required  this.receiverUserID});

  @override
  State<ChatSreen> createState() => _ChatSreenState();
}

class _ChatSreenState extends State<ChatSreen> {
    final TextEditingController _messageController =TextEditingController();
  final ChatService _chatService =ChatService();
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text
      );
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
       AppBar(
        title: Row(
          children: [
            Text(widget.receiverUserName),
            const SizedBox(width: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('utilisateur').doc(widget.receiverUserID).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.data() == null || (snapshot.data!.data() as Map<String, dynamic>?)?['status'] == null) {
                  return Text('Status not available');
                } else {
                  final status = (snapshot.data!.data() as Map<String, dynamic>?)?['status'];
                  final statusText = status == 'online' ? 'Online' : 'Offline';
                  final statusColor = status == 'online' ? Colors.green : Colors.red;

                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: statusColor,
                        radius: 5,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusText,
                        style: TextStyle(color: statusColor),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      
      
      
      
      body: Column(children: [
        //messages
        Expanded(child: _buildMessageList(),
        ),
        //user input
        _buildMessageInput(),
        const SizedBox(height: 25,)
      ]),
    );
  }
  //build msg list
Widget _buildMessageList(){
  return StreamBuilder(
    stream: _chatService.getMessages(
      widget.receiverUserID,
       _firebaseAuth.currentUser!.uid),
   builder: (context,snapshot){
    if(snapshot.hasError){
      return Text("Something went wrong!");
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Text('Loading...');
    }
    return ListView(
      children: snapshot.data!.docs.map((document) => 
      _buildMessageItem(document)).toList(),
    );
   });
}
  //build msg item
Widget _buildMessageItem(DocumentSnapshot document){
  Map<String , dynamic> data =document.data() as Map<String, dynamic>;
  
  //align the msg  to the right if the sender is the current user, ohterwise to the left
  var alignment =(data['senderId']==_firebaseAuth.currentUser!.uid)
  ? Alignment.centerRight
  :Alignment.centerLeft;
  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
          (data['senderId']== _firebaseAuth.currentUser!.uid)
          ?CrossAxisAlignment.end
          :CrossAxisAlignment.start,
          mainAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ?MainAxisAlignment.end
          : MainAxisAlignment.start,
        children: [
      Text(data['senderName']),
      const SizedBox(height: 5),
        ChatBubble(message: data['message'],)
      ],
      ),
    ),
  );
}
  //build msg input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(children: [
        Expanded(child: 
        TextField(
          controller: _messageController,
          
          obscureText: false,
        ),),
        //send btn
        IconButton(onPressed: sendMessage,
         icon: const Icon(
          Icons.arrow_upward,size: 40,
         ))
      ],),
    );
  }
}
 