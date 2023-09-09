import 'package:catch_it_project/core/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressPro extends ChangeNotifier {
  bool? loading = false;
  addAddress(Address address, BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("address")
          .add(address.toFirestore());
      loading = false;
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "Address added", timeInSecForIosWeb: 1, fontSize: 16.0);
      notifyListeners();
    } catch (e) {
      print("Error adding address: $e");
    }
  }

  updateAddress(Address address, String productId) async {
    try {
      loading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("address")
          .doc(productId)
          .update(address.toFirestore());
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(FirebaseAuth.instance.currentUser!.email)
      //     .collection("address")
      //     .add(address.toFirestore());
      loading = false;
      Fluttertoast.showToast(
          msg: "Address updated", timeInSecForIosWeb: 1, fontSize: 16.0);
      notifyListeners();
    } catch (e) {
      print("Error adding address: $e");
    }
  }

  Future<QuerySnapshot> getDefaultAddress() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("address")
        .where("isDefault", isEqualTo: true)
        .get();
    return querySnapshot;
  }

  selectAsDefault({selectedAddressId}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("address")
        .where("isDefault", isEqualTo: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference previousDefaultDocRef =
          querySnapshot.docs.first.reference;
      await previousDefaultDocRef.update({"isDefault": false});
      notifyListeners();
    }
    DocumentReference defaultDOcRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("address")
        .doc(selectedAddressId);
    await defaultDOcRef.update({"isDefault": true});
    Fluttertoast.showToast(
        msg: "Default address changed", timeInSecForIosWeb: 1, fontSize: 16.0);
    notifyListeners();
  }
}
