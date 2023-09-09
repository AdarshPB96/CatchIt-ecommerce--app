import 'package:catch_it_project/Presentation/product_view/product_view_screen.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/functions/recently.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:flutter/material.dart';

class HomeHorizontalListviewWidget extends StatelessWidget {
 final List<Product>? products;
  const HomeHorizontalListviewWidget({
    this.products,
    super.key,
    required this.tSize,
  });

  final Size tSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: tSize.height * 0.29,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                addProductToRecentList(products![index].id!);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductViewScreen(product: products![index]),
                ));
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: tSize.height * 0.22,
                      width: tSize.width * 0.27,
                      child: Image.network(
                        products![index].imageurls[0],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: tSize.height * 0.057,
                      width: tSize.width * 0.3,
                      child: Text(
                        products![index].title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return tSizedBoxWidth20;
          },
          itemCount: products?.length != null ? products!.length : 0),
    );
  }
}
