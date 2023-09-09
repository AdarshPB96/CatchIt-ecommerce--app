
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetails {
  String? id;
  String? userEmail;
  List<Cart> cartItems;
  String orderTotalAmount;
  String paymentId;
  String? orderStatus;
  Address? address;
  Timestamp time;

  OrderDetails(
      {required this.cartItems,
      required this.paymentId,
      required this.orderTotalAmount,
      this.orderStatus,
      this.userEmail,
      this.address,
      required this.time,
      this.id});
  factory OrderDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    if (data == null) {
      throw const FormatException('Product data is null in Firestore.');
    }
    List<dynamic> cartItemsData = data['cartItems'];

    List<Cart> cartItems = cartItemsData.map<Cart>((itemData) {
      Map<String, dynamic> cartData = itemData as Map<String, dynamic>;
      return Cart(
        productId: cartData['productId'],
        quantity: cartData['quantity'],
        totalprice: cartData['totalprice'],
      );
    }).toList();

    Map<String, dynamic>? addressData = data['address'];

    // Construct an Address object from the address data
    Address? address;
    if (addressData != null) {
      address = Address(
        id: addressData['id'],
        name: addressData['name'],
        address: addressData['address'],
        city: addressData['city'],
        state: addressData['state'],
        pin: addressData['pin'],
        phone: addressData['phone'],
        isDefault: addressData['isDefault'],
      );
    }
  dynamic timeData = data['time'];
  Timestamp timestamp;

  if (timeData is Timestamp) {
    timestamp = timeData;
  } else if (timeData is String) {
    timestamp = Timestamp.fromDate(DateTime.parse(timeData));
  } else {
    throw const FormatException('Invalid time data format');
  }

    return OrderDetails(
        id: doc.id,
        cartItems: cartItems,
        paymentId: data['paymentId'] ?? '',
        orderTotalAmount: data['orderTotalAmount'] ?? '',
        userEmail: data['userEmail'] ?? '',
        orderStatus: data['orderStatus'] ?? 'Live',
        time: timestamp ,
        address: address);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cartItems': cartItems.map((cartItem) => cartItem.toFirestore()).toList(),
      'paymentId': paymentId,
      'orderTotalAmount': orderTotalAmount,
      'userEmail': FirebaseAuth.instance.currentUser!.email,
      'orderStatus': orderStatus ?? 'Live',
      'address': address?.toFirestore(),
      'time' : time 

    };
  }
}
