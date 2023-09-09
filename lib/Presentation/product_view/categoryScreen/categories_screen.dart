
import 'package:catch_it_project/Presentation/product_view/product_view_screen.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:flutter/material.dart';
import '../../../constants/size_color_constants.dart';

class CategoryScreen extends StatelessWidget {
 final String categoryName;
 final List<Product> products;
  const CategoryScreen(
      {required this.categoryName, required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductViewScreen(product: products[index]),
                    ));
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
                ],
              ),
            );
          },
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 25,
          ),
        ),
      )),
    );
  }
}
