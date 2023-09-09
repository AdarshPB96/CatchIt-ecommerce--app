import 'package:catch_it_project/core/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import '../../../core/models/address_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  Future<void> createOrderAndDeleteCartItems({
    required String paymentId,
    required List<Cart> cartItems,
    required String totalAmount,
  }) async {
    Address? defaultAddress = await getDefaultAddress();
    await _orderService.createOrderAndDeleteCartItems(
      paymentId: paymentId,
      cartItems: cartItems,
      totalAmount: totalAmount,
      defaultAddress: defaultAddress,
    );
    notifyListeners();
  }
}

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrderAndDeleteCartItems({
    required String paymentId,
    required List<Cart> cartItems,
    required String totalAmount,
    Address? defaultAddress,
  }) async {
    DocumentReference orderRef = _firestore.collection('orders').doc();

    // Convert the cart items to Firestore-friendly data

    OrderDetails order = OrderDetails(
        cartItems: cartItems, // Use the List<Cart> directly
        paymentId: paymentId,
        orderTotalAmount: totalAmount,
        address: defaultAddress,
        time: Timestamp.now());

    await orderRef.set(order.toFirestore());

    for (Cart cartItem in cartItems) {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .collection('cart')
          .doc(cartItem.productId)
          .delete();
    }
  }
}

Future<Address?> getDefaultAddress() async {
  String currentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(currentUserEmail)
      .collection("address")
      .where("isDefault", isEqualTo: true)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot addressSnapshot = querySnapshot.docs[0];
    Address address = Address.fromFirestore(addressSnapshot);
    return address;
  } else {
    return null;
  }
}
