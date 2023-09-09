import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/account.dart';

class AccountPro extends ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var pickedImageUrl;
  var img;
  bool loading = false;
  Future pickImage() async {
    //  final ImagePicker _picker = ImagePicker();
    final XFile? response =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (response != null) {
      final image = File(response.path);

      img = image;
      pickedImageUrl = await uploadImages(image);
      notifyListeners();
    } else {
      return;
    }

    // final XFile? image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadImages(File image) async {
    try {
      log("yessssssssssssssssssssssssssssssssssssssssssssssss");
      String imageurl;

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('account_image/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      if (taskSnapshot.state == TaskState.success) {
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageurl = imageUrl;

        print("Image Upload Successful. URL: $imageurl");

        return imageurl;
      } else {
        print("Image Upload Failed");
        return '';
      }
    } catch (error) {
      return '';
    }
  }

  Future<void> addOrUpdateAccountDetails(Account account) async {
    CollectionReference accountRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("account");
    loading = true;
    // Check if a document already exists
    QuerySnapshot querySnapshot = await accountRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a document exists, update it
      DocumentReference docRef = querySnapshot.docs[0].reference;
      await docRef.update(account.toFirestore());
    } else {
      // If no document exists, add a new one
      await accountRef.add(account.toFirestore());
    }
    loading = false;
    notifyListeners();
  }
}
