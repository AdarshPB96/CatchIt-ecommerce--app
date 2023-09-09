 
//   import 'package:cloud_firestore/cloud_firestore.dart';

// Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();

//   ordersStream.listen((QuerySnapshot snapshot) {
//   orderList.clear();
//   shippedList.clear();
//   outOfDeliveryList.clear();
//   deliveredList.clear();

//   for (QueryDocumentSnapshot doc in snapshot.docs) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     String orderStatus = data['orderStatus'];

//     OrderDetails orderDetails = OrderDetails.fromFirestore(data); // Create an OrderDetails object

//     if (orderStatus == 'Placed') {
//       orderList.add(orderDetails);
//     } else if (orderStatus == 'Shipped') {
//       shippedList.add(orderDetails);
//     } else if (orderStatus == 'Out for Delivery') {
//       outOfDeliveryList.add(orderDetails);
//     } else if (orderStatus == 'Delivered') {
//       deliveredList.add(orderDetails);
//     }
//   }

//   // Now you have classified orders into different lists
//   // You can use these lists in your OrderTracker widget or other parts of your UI
// });