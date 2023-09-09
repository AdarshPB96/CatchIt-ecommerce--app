import 'package:cloud_firestore/cloud_firestore.dart';
class Account {
  String? id;
  String imageUrl;
  String name;
  Account({required this.imageUrl, required this.name, this.id});

  factory Account.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (data == null) {
      throw const FormatException('Product data is null in Firestore.');
    }
    return Account(imageUrl: data["imageUrl"], name: data["name"], id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "imageUrl": imageUrl,
      "name": name,
      "id": FieldValue.serverTimestamp()
    };
  }
}
