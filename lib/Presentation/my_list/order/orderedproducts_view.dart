import 'package:catch_it_project/Presentation/address_screen/widgets/address_widget.dart';
// import 'package:catch_it_project/Presentation/my_cart/functions/provider/cart_provider.dart';
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:catch_it_project/core/models/order_model.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../constants/size_color_constants.dart';

class OrderedProductsView extends StatelessWidget {
  OrderDetails order;

  OrderedProductsView({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      List<Cart> cartItems = order.cartItems;
                      Cart cartItem = cartItems[index];
                      String productId = cartItems[index].productId;
                      print(
                          ".....................././/////////Number of cart items: ${cartItems.length}");
           
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .doc(
                                productId) // Assuming 'productId' is the document ID in the 'products' collection
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          DocumentSnapshot<Map<String, dynamic>>
                              productSnapshot = snapshot.data!;
                          Product product =
                              Product.fromFirestore(productSnapshot);
                          //                 // Now you can use the product data to display information
                          return InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => categoryi,))
                            },
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child:
                                          Image.network(product.imageurls[0]),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          tSizedBoxHeight10,
                                          Text(
                                            product.subtitle,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          tSizedBoxHeight10,
                                          Text(
                                            "Qty : ${cartItem.quantity}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          tSizedBoxHeight10,
                                          Text(
                                            "Total price"
                                            "₹ ${cartItem.totalprice}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 3,
                      );
                    },
                    itemCount: order.cartItems.length),
                tSizedBoxHeight30,
                const Text(
                  "Address",
                  style: TextStyle(fontSize: 22),
                ),
                order.address != null
                    ? addressWidget(
                        context: context,
                        address: order.address as Address,
                      )
                    : const SizedBox(),
                tSizedBoxHeight30,
                Text("Total Order Price: ${order.orderTotalAmount}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        )
        );
  }
}
