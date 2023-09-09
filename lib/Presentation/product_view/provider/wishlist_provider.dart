
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WishlistPro extends ChangeNotifier {
  addOrRemoveFromWishlist({required productId}) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    CollectionReference wishlistRef = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection('wishlist');
    QuerySnapshot wishlistSnapshot = await wishlistRef.get();
    List<String> wishlistProductIds =
        wishlistSnapshot.docs.map((doc) => doc.id).toList();
    if (wishlistProductIds.contains(productId)) {
      await wishlistRef.doc(productId).delete();
      Fluttertoast.showToast(
          msg: "Removed from wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      notifyListeners();
    } else {
      await wishlistRef.doc(productId).set({'wishlistId': productId});
      Fluttertoast.showToast(
          msg: "Added to wishlist", timeInSecForIosWeb: 1, fontSize: 16.0);
      notifyListeners();
    }
  }

  isAlready({required productId}) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    CollectionReference wishlistRef = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection('wishlist');
    QuerySnapshot wishlistSnapshot = await wishlistRef.get();
    List<String> wishlistProductIds =
        wishlistSnapshot.docs.map((doc) => doc.id).toList();
    if (wishlistProductIds.contains(productId)) {
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}
