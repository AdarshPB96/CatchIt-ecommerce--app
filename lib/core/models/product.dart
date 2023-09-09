
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String? category;
  String title;
  String subtitle;
  String description;
  List imageurls;
  String price;
  String pdfurl;
  int? quantity;

  Product(
      {required this.title,
      required this.category,
      required this.subtitle,
      required this.description,
      required this.imageurls,
      required this.price,
      required this.pdfurl,
      required this.quantity,
      required this.id});
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    if (data == null) {
      throw const FormatException(
          'Product data is null in Firestore.'); // Handle if data is null
    }

    return Product(
      id: doc.id,
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      description: data['description'] ?? '',
      imageurls: data['imageurls'] ?? [],
      price: data['price'] ??
          0.0.toString(), // Provide a default value for price if null
      pdfurl: data['pdfurl'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}
