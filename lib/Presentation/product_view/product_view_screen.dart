import 'dart:convert';
import 'package:catch_it_project/Presentation/my_cart/functions/provider/mycartpro.dart';
import 'package:catch_it_project/Presentation/my_list/downloads/functions_download.dart';
import 'package:catch_it_project/Presentation/product_view/provider/wishlist_provider.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/functions/wishlist.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductViewScreen extends StatelessWidget {
 final Product product;
  const ProductViewScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final tcatPro = Provider.of<CartPro>(context);
    final tSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.shopping_cart))
                  ],
                ),
                tSizedBoxHeight10,
                Center(
                  child: SizedBox(
                    height: tSize.height * 0.4,
                    width: tSize.width * 0.8,
                    child: PageView.builder(
                      itemCount: product.imageurls.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          child: Center(
                            child: Image.network(
                              product.imageurls[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Consumer<WishlistPro>(
                      builder: (context, value, child) {
                        return FutureBuilder(
                          future: isAlreadyInWishlist(productId: product.id),
                          builder: (context, snapshot) {
                            return IconButton(
                                onPressed: () {
                                  value.addOrRemoveFromWishlist(
                                      productId: product.id);
                                },
                                icon: snapshot.data == true
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      )
                                    : const Icon(Icons.favorite,
                                        color: Colors.blue));
                          },
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  product.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                tSizedBoxHeight10,
                Row(
                  children: [
                    Text(
                      "₹ ${product.price}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                        onPressed: () async {
                          downloadAndStorePDF(product.pdfurl,
                              product.imageurls[0], product.title);

                          // DownloadProductService().addDownloadRecord(
                          //     product.id.toString(), product.pdfurl);
                        },
                        icon: const Icon(Icons.download),
                        label: Column(
                          children: const [
                            SizedBox(height: 5),
                            Text("CatchIt edition"),
                            Text(
                              'free',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ],
                ),
                tSizedBoxHeight20,
                const Text(
                  "Discription",
                  style: TextStyle(fontSize: 17),
                ),
                tSizedBoxHeight10,
                Text(product.description),
                tSizedBoxHeight10,
                SizedBox(
                  height: tSize.height * 0.1,
                  width: tSize.width,
                  child: Row(children: [
                    SizedBox(
                      height: double.infinity,
                      // width: tSize.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          tcatPro.addToCart(
                              productId: product.id!, price: product.price);
                          Fluttertoast.showToast(
                              msg: "Added to cart", fontSize: 16.0);
                        },
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    tSizedBoxWidth10,
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        // width: tSize.width / 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Buynow ₹ ${product.price}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Future<List<DownloadedItem>> getDownloadedPDFs() async {
  final prefs = await SharedPreferences.getInstance();
  final downloadedItemsJson = prefs.getString('downloaded_items');
  List<DownloadedItem> downloadedItems = [];

  if (downloadedItemsJson != null) {
    final decodedItems = jsonDecode(downloadedItemsJson) as List<dynamic>;
    downloadedItems = decodedItems
        .map((itemJson) => DownloadedItem.fromJson(itemJson))
        .toList();
  }

  return downloadedItems;
}

