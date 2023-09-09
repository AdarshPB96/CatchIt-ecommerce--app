import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addProductToRecentList(String productId) async {
  final email = FirebaseAuth.instance.currentUser?.email;

  CollectionReference recentList = FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .collection('recently');

  try {
    DocumentSnapshot doc = await recentList.doc("list").get();

    if (!doc.exists) {
      await recentList.doc("list").set({'productIds': []});

      doc = await recentList.doc("list").get();
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<dynamic> currentList = data['productIds'] ?? [];

    currentList.add(productId);

    if (currentList.length > 10) {
      currentList.removeRange(0, currentList.length - 10);
    }

    await recentList.doc("list").set({'productIds': currentList});
  } catch (e) {
    print("Error adding product to recent list: $e");
  }
}
