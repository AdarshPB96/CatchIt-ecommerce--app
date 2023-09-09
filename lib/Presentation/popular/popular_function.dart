import 'package:catch_it_project/core/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getPopularItemsStream(int quantityThreshold) {
    return _firestore.collection('products')
        .where('quantity', isLessThanOrEqualTo: quantityThreshold)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((docSnapshot) {
              return Product.fromFirestore(docSnapshot);
            }).toList());
  }

  Stream<List<Product>> getNewlyAddedProductsStream() {
  return _firestore
      .collection('products')
      .orderBy('id', descending: true)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.map((docSnapshot) {
            return Product.fromFirestore(docSnapshot);
          }).toList());
}

}

