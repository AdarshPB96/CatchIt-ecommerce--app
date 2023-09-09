import 'package:catch_it_project/Presentation/my_list/order/orderedproducts_view.dart';
import 'package:catch_it_project/Presentation/my_list/order/tracking_screen.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:catch_it_project/core/models/order_model.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/gridview_widget.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              tSizedBoxHeight20,
              TabBar(
                  // isScrollable: true,
                  labelColor: tBlack,
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.5)),
                  tabs: const [
                    Tab(
                      text: "Orders",
                    ),
                    Tab(
                      text: "Downloads",
                    ),
                  ]),
              tSizedBoxHeight10,
              Expanded(
                  child: TabBarView(children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('userEmail',
                          isEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No Orders yet"),
                      );
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        orderDocs = snapshot.data!.docs;
                    List<OrderDetails> orders = orderDocs
                        .map((doc) => OrderDetails.fromFirestore(doc))
                        .toList()
                        .reversed
                        .toList();

                    return ListView.separated(
                        // scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, orderIndex) {
                          OrderDetails order = orders[orderIndex];
                          List<Cart> cartItems = order.cartItems;
                          // final orderNumber = orderIndex + 1;
                          final orderNumbers = orders.length;

                          // Product product = productMap[cartItem.productId]!;
                          // print("");
                          // ".....................././/////////Number of cart items: ${cartItems.length}");

                          return InkWell(
                            child: Card(
                              margin: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          // order.id.toString(),
                                          "Order No : ${orderNumbers - orderIndex}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        TextButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrackOrder(
                                                            order: order,
                                                          )));
                                            },
                                            icon:
                                                const Icon(Icons.track_changes),
                                            label: const Text("Track"))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Date and Time: ${order.time.toDate()}'),
                                  ),
                                  SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: order.cartItems.length,
                                        itemBuilder: (context, index) {
                                          String productId =
                                              cartItems[index].productId;

                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(productId)
                                                .snapshots(),
                                            builder: (context, streamSnapshot) {
                                              if (streamSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              DocumentSnapshot<
                                                      Map<String, dynamic>>
                                                  productSnapshot =
                                                  streamSnapshot.data
                                                      as DocumentSnapshot<
                                                          Map<String, dynamic>>;
                                              Product product =
                                                  Product.fromFirestore(
                                                      productSnapshot);

                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                    product.imageurls[0],
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.contain,
                                                  ));
                                            },
                                          );
                                        },
                                      )),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    OrderedProductsView(order: order),
                              ));
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 5,
                          );
                        },
                        itemCount:
                            //  cartItems.length
                            orders.length);
                  },
                ),
                const DownloadsGridview()
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
