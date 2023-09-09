import 'package:catch_it_project/Presentation/address_screen/address_screen.dart';
import 'package:catch_it_project/Presentation/my_cart/functions/provider/mycartpro.dart';
import 'package:catch_it_project/Presentation/payment_screen/payment_screen.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../address_screen/widgets/address_widget.dart';

// ignore: must_be_immutable
class OrderSummaryScreen extends StatelessWidget {
  OrderSummaryScreen({super.key});
  late List<Cart> cartItems;
  late String totalAmount;

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    final tCartpro = Provider.of<CartPro>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            tSizedBoxHeight10,
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                SizedBox(
                  width: tSize.width * 0.2,
                ),
                const Center(
                  child: Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            tSizedBoxHeight20,
            const Divider(
              thickness: 2,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection("address")
                    .where("isDefault", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // if (snapshot.hasError) {
                  //   print(
                  //       "snapshot in address has errrorrrrrrrrrrrrrrrrrrrrrr");
                  // }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddresScreen(),
                              ));
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add address"));
                  }
                  Address defaultAddress =
                      Address.fromFirestore(snapshot.data!.docs.first);

                  return addressWidget(
                      changeButton: true,
                      context: context,
                      address: defaultAddress);
                }),
            tSizedBoxHeight10,
            const Divider(
              thickness: 2,
            ),
            tSizedBoxHeight10,
            FutureBuilder(
              future: Future.wait(
                  [tCartpro.getProductMap(), tCartpro.getCartDetails()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                Map<String, Product> productMap =
                    snapshot.data?[0] as Map<String, Product>;
                cartItems = (snapshot.data?[1] as List<dynamic>).cast<Cart>();
                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Cart cartItem = cartItems[index];
                      Product product = productMap[cartItem.productId]!;
                      print("");

                      return InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.network(product.imageurls[0]),
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
                                        style: const TextStyle(fontSize: 18),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      tSizedBoxHeight10,
                                      Text(
                                        "₹ ${cartItem.totalprice}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      tSizedBoxHeight10,
                                      Text(
                                        "Qty -${cartItem.quantity}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 5,
                      );
                    },
                    itemCount: cartItems.length);
              },
            ),
            tSizedBoxHeight30,
            FutureBuilder(
              future: tCartpro.getTotalCartValue(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                totalAmount = snapshot.data.toString();

                return double.parse(totalAmount) <= 0
                    ? const Center(child: Text("No items"))
                    : Container(
                        color: Colors.grey,
                        height: tSize.height * 0.09,
                        child: Row(children: [
                          tSizedBoxWidth10,
                          const Text(
                            'Total price',
                            style: TextStyle(color: tBlack, fontSize: 20),
                          ),
                          tSizedBoxWidth10,
                          Text(
                            snapshot.data.toString(),
                            style: const TextStyle(
                                fontSize: 24,
                                color: tBlack,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: double.infinity,
                            width: tSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderPaymentScreen(
                                          cartItems: cartItems,
                                          totalAmount: totalAmount),
                                    ));
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ]),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
