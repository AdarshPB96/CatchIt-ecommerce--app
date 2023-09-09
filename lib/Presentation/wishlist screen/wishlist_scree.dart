import 'package:catch_it_project/Presentation/my_list/widgets/vertical_listview.dart';
import 'package:catch_it_project/Presentation/product_view/provider/wishlist_provider.dart';
import 'package:catch_it_project/core/functions/wishlist.dart';
import 'package:catch_it_project/core/models/product.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tWishlistPro = Provider.of<WishlistPro>(context);
    return Scaffold(
        body: FutureBuilder(
      future: getwishlistListProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final List<Product> products = snapshot.data!;
        
        return  Column(
          children: [
            listColornamedContainer(
                context: context,
                color: const Color.fromARGB(255, 54, 18, 233),
                name: "Your Wishlist"),
            Expanded(
                child:
                    verticalListView(products: products, favDeleteButton: true,wishlistPro: tWishlistPro))
          ],
        );
      },
    ));
  }

  Container listColornamedContainer(
      {required Color color,
      required String name,
      required BuildContext context}) {
    return Container(
      width: double.infinity,
      height: 150,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          Text(
            name,
            style: const TextStyle(
                fontSize: 50, fontFamily: "KaushanScript", color: Colors.white),
          ),
        ],
      ),
    );
  }
}
