import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String productId;
  String quantity;
  String totalprice;
 

  Cart(
      {required this.productId,
      required this.quantity,
      required this.totalprice,
      });

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    if (data == null || data.isEmpty) {
      throw const FormatException("Cart data is empty in Firestore");
    }
    return Cart(
      productId: data['productId'],
      quantity: data['quantity'].toString(),
      totalprice: data['totalprice'],

      
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'quantity': quantity,
      'totalprice': totalprice,
    };
  }

  // factory Cart.toFirestore(Cart cart) {
  //   Map<String, dynamic>? data = cart as Map<String, dynamic>;
  //   return Cart(
  //       productId: 'productId', quantity: 'quantity', totalprice: 'totalprice');
  // }
}
