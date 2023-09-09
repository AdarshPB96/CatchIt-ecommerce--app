import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

Future<List<Product>> getwishlistListProducts() async {
  final email = FirebaseAuth.instance.currentUser?.email;
  List<Product> wishlistProducts = [];
  // var wishlist = [];
  CollectionReference wishlistRef = FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .collection('wishlist');
  QuerySnapshot wishlistSnapshot = await wishlistRef.get();
  List<String> wishlistProductIds =
      wishlistSnapshot.docs.map((doc) => doc.id).toList();
  CollectionReference productRef =
      FirebaseFirestore.instance.collection("products");
  for (String productId in wishlistProductIds) {
    DocumentSnapshot productSnapshot = await productRef.doc(productId).get();
    if (productSnapshot.exists) {
      wishlistProducts.add(Product.fromFirestore(productSnapshot));
    }
  }
  return wishlistProducts;
}

addOrRemoveFromWishlist({required productId}) async {
  final email = FirebaseAuth.instance.currentUser?.email;
  CollectionReference wishlistRef = FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .collection('wishlist');
  QuerySnapshot wishlistSnapshot = await wishlistRef.get();
  List<String> wishlistProductIds =
      wishlistSnapshot.docs.map((doc) => doc.id).toList();

  for (String element in wishlistProductIds) {
    if (element == productId) {
      return await wishlistRef.doc(productId).delete();
    }
  }

  await wishlistRef.doc(productId).set({'wishlistId': productId});
}

Future<bool> isAlreadyInWishlist({required productId}) async {
  final email = FirebaseAuth.instance.currentUser?.email;
  CollectionReference wishlistRef = FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .collection('wishlist');
  QuerySnapshot wishlistSnapshot = await wishlistRef.get();
  List<String> wishlistProductIds =
      wishlistSnapshot.docs.map((doc) => doc.id).toList();

  if (wishlistProductIds.contains(productId)) {
    return true;
  }
  return false;
}

Stream<List<Product>> wishlistListProductsStream() {
  final email = FirebaseAuth.instance.currentUser?.email;

  Stream<QuerySnapshot> wishlistSnapshotStream = FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .collection('wishlist')
      .snapshots();

  return wishlistSnapshotStream.asyncMap((wishlistSnapshot) async {
    List<Product> wishlistProducts = [];

    List<String> wishlistProductIds =
        wishlistSnapshot.docs.map((doc) => doc.id).toList();

    CollectionReference productRef =
        FirebaseFirestore.instance.collection("products");

    for (String productId in wishlistProductIds) {
      DocumentSnapshot productSnapshot = await productRef.doc(productId).get();
      if (productSnapshot.exists) {
        wishlistProducts.add(Product.fromFirestore(productSnapshot));
      }
    }

    return wishlistProducts;
  });
}
