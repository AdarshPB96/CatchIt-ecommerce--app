import 'package:catch_it_project/Presentation/product_view/provider/wishlist_provider.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:flutter/material.dart';

Widget verticalListView(
    {required List<Product> products,
    bool? favDeleteButton,
    WishlistPro? wishlistPro}) {
  return FutureBuilder(
    builder: (context, snapshot) => ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => categoryi,))
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.network(
                  products[index].imageurls[0],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products[index].title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    tSizedBoxHeight10,
                    Text(
                      products[index].subtitle,
                      style: const TextStyle(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    tSizedBoxHeight10,
                    Text(
                      "₹ ${products[index].price}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              favDeleteButton == true
                  ? IconButton(
                      onPressed: () {
                        wishlistPro?.addOrRemoveFromWishlist(
                            productId: products[index].id);
                      },
                      icon: const Icon(Icons.delete))
                  : const SizedBox()
            ],
          ),
        );
      },
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 25,
      ),
    ),
  );
}
