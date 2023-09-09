import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String? id;
  String? name;
  String address;
  String city;
  String state;
  String pin;
  String phone;
  bool ? isDefault;
  Address({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pin,
    required this.phone,
    this.isDefault ,
  });
  factory Address.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    if (data == null) {
      throw const FormatException(
          'Product data is null in Firestore.'); // Handle if data is null
    }

    return Address(
        id: doc.id,
        name: data["name"],
        address: data["address"],
        city: data["city"],
        state: data["state"],
        pin: data["pin"],
        phone: data["phone"],
        isDefault: data["isDefault"] ?? false);
        
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ?? FieldValue.serverTimestamp(),
      "name": name,
      "address": address,
      "city": city,
      "state": state,
      "pin": pin,
      "phone": phone,
      "isDefault" : isDefault,
    };
  }
}
