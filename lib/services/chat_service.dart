import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/message.dart';


class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String?> getUserName() async {
    final String currUserId = _firebaseAuth.currentUser!.uid;

    try {
      DocumentSnapshot userSnapshot = await _fireStore
          .collection('utilisateur')
          .doc(currUserId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('fullname');
      } else {
        return null; // Handle case where user data is not available
      }
    } catch (e) {
      print('Error fetching user information: $e');
      return null; // Handle potential errors
    }
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currUserId = _firebaseAuth.currentUser!.uid;
    final String? currUserName = await getUserName(); // Fetch current user's username

    if (currUserName != null) {
      try {
        Timestamp timestamp = Timestamp.now();

        Message newMessage = Message(
          senderId: currUserId,
          senderName: currUserName,
          receiverId: receiverId,
          message: message,
          timestamp: timestamp,
        );

        List<String> ids = [currUserId, receiverId];
        ids.sort();
        String chatRoomId = ids.join("_");

        await _fireStore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add(newMessage.toMap());
      } catch (e) {
        print('Error sending message: $e');
        // Handle potential errors while sending the message
      }
    } else {
      print('Username not available'); // Handle case where username is not available
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}