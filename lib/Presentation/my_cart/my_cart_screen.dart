
import 'package:catch_it_project/Presentation/my_cart/functions/provider/mycartpro.dart';
import 'package:catch_it_project/Presentation/order_summary/order_summary.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tpro = Provider.of<CartPro>(context);

    final tSize = MediaQuery.of(context).size;
    Map<String, dynamic>? productMap;
    return FutureBuilder(
      future: tpro.getProductMap(),
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        productMap = productSnapshot.data ?? {};

        return StreamBuilder<List<Cart>>(
            stream: tpro.getCartDetailsStream(),
            builder: (context, cartSnapshot) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(
                    child: cartSnapshot.data?.length == 0
                        ? const Center(
                            child: Text("No cart item"),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tSizedBoxHeight10,
                              const Text(
                                'My Cart',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              tSizedBoxHeight20,
                              Expanded(
                                child: SingleChildScrollView(
                                  child: ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        // print(
                                        //     ".....................././/////////Number of cart items: ${cartItems.length}");

                                        // Cart cartItem = cartItems[index];
                                        Product product = productMap?[
                                            cartSnapshot
                                                .data?[index].productId]!;

                                        return CartItemWidget(
                                          product: product,
                                          tpro: tpro,
                                          data:
                                              cartSnapshot.data?[index] as Cart,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 3,
                                        );
                                      },
                                      itemCount:
                                          cartSnapshot.data?.length ?? 0),
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              )
                            ],
                          ),
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.grey,
                  height: tSize.height * 0.09,
                  child: Row(children: [
                    tSizedBoxWidth10,
                    const Text(
                      'Total price',
                      style: TextStyle(color: tBlack, fontSize: 20),
                    ),
                    tSizedBoxWidth10,
                    FutureBuilder(
                      future: tpro.getTotalCartValue(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                              fontSize: 24,
                              color: tBlack,
                              fontWeight: FontWeight.bold),
                        );
                      },
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
                                builder: (context) => OrderSummaryScreen(),
                              ));
                        },
                        child: const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
              );
            });
      },
    );
  }
}

// ignore: must_be_immutable
class CartItemWidget extends StatelessWidget {
  CartItemWidget({
    super.key,
    required this.product,
    required this.tpro,
    required this.data,
  });

  final Product product;
  final CartPro tpro;
  Cart data;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
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
                    "₹ ${data.totalprice}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tSizedBoxWidth10,
                  DropdownButton<int>(
                    value: int.parse(data.quantity),
                    items: List<DropdownMenuItem<int>>.generate(
                      50,
                      (index) => DropdownMenuItem(
                        value: index + 1, // Corrected this line
                        child: Text("${index + 1}"),
                      ),
                    ),
                    onChanged: (value) async {
                      await tpro.getselectedQuantity(
                        quantity: value as int,
                        cartItemId: data.productId,
                        productPrice: product.price,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        TextButton.icon(
            onPressed: () {
              tpro.deleteFromCart(productId: data.productId as String);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Remove'))
      ],
    );
  }
}
