import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _pickedImage;
  ImagePicker? imagePicker;
  final Random _random = Random();
  String? imageUrl1;

  String generateRandomName(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  final ImagePicker _picker = ImagePicker();

  TextEditingController descripton = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    getUser_Data();
    super.initState();
  }

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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      //thanks for watching
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffB81736),
              Color(0xff281537),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Create Your\nPost',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Form(
                key: formState,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: descripton,
                      maxLength: 40,
                      maxLines: 5,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Descripton',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ]),
                          ),
                          child: MaterialButton(
                            onPressed: () => addCamera(),
                            child: Text(
                              'Camera',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ]),
                          ),
                          child: MaterialButton(
                            onPressed: () => addGallery(),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (imageUrl1 != null)
                      Image.network(imageUrl1!,
                          width: 100, height: 100, fit: BoxFit.fill),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(colors: [
                          Color(0xffB81736),
                          Color(0xff281537),
                        ]),
                      ),
                      child: Center(
                        child: MaterialButton(
                          onPressed: () async {
                            if (formState.currentState!.validate()) {
                              final randomName = generateRandomName(10);
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('photos')
                                  .child(randomName + '.jpg');
                              await ref.putFile(_pickedImage!);
                              imageUrl1 = await ref.getDownloadURL();
                              print(imageUrl1);
                              final User? _userr =
                                  FirebaseAuth.instance.currentUser;
                              final _uid = _userr!.uid;
                              await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(_uid)
                                  .set({
                                "descripton": descripton.text,
                                "fullname": user_data["fullname"],
                                "photo": imageUrl1,
                                'id': user_data["id"],
                              });
                               Navigator.of(context)
                                                .pushNamedAndRemoveUntil("home", (route) => false);
                            }
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  addCamera() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    _pickedImage = File(pickedFile!.path);
    // notifyListeners();
    if (_pickedImage != null) {
      _pickedImage;

      // notifyListeners();
    } else {}
  }

  addGallery() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _pickedImage = File(pickedFile!.path);
    // notifyListeners();
    if (_pickedImage != null) {
      _pickedImage;
      // notifyListeners();
    } else {}
  }
}
