import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePostScreen extends StatefulWidget {
  final String postId; // Identifiant unique du post que vous souhaitez mettre à jour

  const UpdatePostScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  File? _pickedImage;
  ImagePicker _picker = ImagePicker();
  String? imageUrl1;
  TextEditingController descripton = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Charger les données existantes du post
    loadPostData();
  }

  loadPostData() async {
    // Récupérer les données du post existant
    var postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .get();

    // Remplir les champs du formulaire avec les données existantes
    setState(() {
      descripton.text = postSnapshot['descripton'];
      imageUrl1 = postSnapshot['photo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: descripton,
                maxLength: 40,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 16.0),
              if (imageUrl1 != null)
                Image.network(imageUrl1!,
                    width: 100, height: 100, fit: BoxFit.fill),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _pickImage(),
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _updatePost(),
                child: Text('Update Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  _updatePost() async {
    if (formState.currentState!.validate()) {
      if (_pickedImage != null) {
        // Mettre à jour l'image s'il y a une nouvelle image
        final randomName = _generateRandomName(10);
        final ref = FirebaseStorage.instance
            .ref()
            .child('photos')
            .child(randomName + '.jpg');
        await ref.putFile(_pickedImage!);
        imageUrl1 = await ref.getDownloadURL();
      }

      // Mettre à jour les données du post dans Firestore
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        "descripton": descripton.text,
        "photo": imageUrl1,
      });

      // Retourner à la page précédente
      Navigator.pop(context);
    }
  }

  String _generateRandomName(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
  }
}