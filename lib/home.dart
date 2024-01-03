import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<QueryDocumentSnapshot> data = [];
  //getData() async {
  //QuerySnapshot querySnapshot =
  //  await FirebaseFirestore.instance.collection('posts').get();
  //data.addAll(querySnapshot.docs);
  //setState(() {});
  //}

  @override
  void initState() {
    getUser_Data();
    super.initState();
  }

  TextEditingController _commentTextController = TextEditingController();
  var user_data;

  Future<DocumentSnapshot> getUser_Data() async {
    final User? user1 = FirebaseAuth.instance.currentUser;
    String? _uid = user1!.uid;
    var result1 = await FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(_uid)
        .get();
    setState(() {
      user_data = result1;
    });
    return result1;
  }

  void addComment(String postId, String commentText) {
    final User? _userr = FirebaseAuth.instance.currentUser;
    final _uid = _userr!.uid;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": user_data["fullname"],
    });
  }

  void showCommentDialog(BuildContext context, String postId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a comment..."),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    addComment(postId, _commentTextController.text);
                    Navigator.pop(context);

                    _commentTextController.clear();
                  },
                  child: Text("Post"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _commentTextController.clear();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ));
  }

  final List _posts = ['post 1', 'post 2', 'post 3', 'post 4', 'post 5'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Social Media"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("login");
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];
                    var postId = document.id;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 3),
                                  child: SizedBox(
                                    height: 55,
                                    width: 55,
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: ClipOval(
                                        child: Image(
                                          height: 68,
                                          width: 68,
                                          image: AssetImage('assets/women.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "${document['fullname']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: NetworkImage("${document['photo']}"),
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_outline_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () => showCommentDialog(context, postId),
                                child: Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Icon(
                                Icons.near_me_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '133 likes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "${document['fullname']}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${document['descripton']}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'view 54 comments',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '2 days ago',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postId)
                                .collection("Comments")
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, commentIndex) {
                                  var commentDocument =
                                      snapshot.data!.docs[commentIndex];
                                  // Utilisez commentDocument pour afficher les détails du commentaire
                                  return ListTile(
                                    title: Text(
                                        "${commentDocument['CommentText']}",style: TextStyle(
                                color: Colors.white,
                              ),),
                                    subtitle: Text(
                                        "${commentDocument['CommentedBy']}",style: TextStyle(
                                color: Colors.white,
                              ),),
                                  );
                                },
                              );
                            }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
