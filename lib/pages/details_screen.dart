import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_media/pages/profil_screen.dart';

import 'edit_post.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffB81736),
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilScreen(),
                    ));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2.8 / 3.4,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        //alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(115, 227, 206, 206),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${document['photo']}"))),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${document['descripton']}",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context)=> UpdatePostScreen(postId: document.id)));
                                    },
                                    child: Icon(
                                      Icons.update,
                                      color: Colors.green,
                                    )),
                                SizedBox(width: 5),
                                InkWell(
                                    onTap: () {
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: 'Erreur',
                                          desc: 'Are you sure to delete?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () async {
                                            await FirebaseFirestore.instance
                                                .collection("posts")
                                                .doc(document.id)
                                                .delete();
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    "details");
                                          }).show();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
