import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:catch_it_project/Presentation/home/widgets/horizontal_listview.dart';
import 'package:catch_it_project/Presentation/home/widgets/widgets.dart';
import 'package:catch_it_project/Presentation/popular/popular_function.dart';
import 'package:catch_it_project/Presentation/product_view/categoryScreen/categories_screen.dart';
import 'package:catch_it_project/Presentation/product_view/product_view_screen.dart';
import 'package:catch_it_project/Presentation/wishlist%20screen/wishlist_scree.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/functions/wishlist.dart';
import 'package:catch_it_project/core/models/product.dart';
import 'package:catch_it_project/domain/firebase/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
  final TextEditingController searachController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var products = snapshot.data!.docs
              .map((doc) => Product.fromFirestore(doc))
              .toList();
          var categories = snapshot.data!.docs
              .map((doc) => doc["category"])
              .toSet()
              .toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(width: 20.0, height: 80.0),
                      DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'KaushanScript',
                            color: Color.fromARGB(255, 31, 230, 38)),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText('Be AWESOME'),
                            RotateAnimatedText('Be OPTIMISTIC'),
                            RotateAnimatedText('Be DIFFERENT'),
                          ],
                          repeatForever: true,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    child: TextField(
                      controller: searachController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(
                            Icons.search,
                          ),
                          hintText: "Search",
                          suffixIcon: IconButton(
                              onPressed: () {
                                searachController.clear();
                                setState(() {
                                  filteredProducts.clear();
                                });
                              },
                              icon: const Icon(Icons.clear))),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            isSearching = false;
                            filteredProducts.clear();
                          } else {
                            isSearching = true;
                            filteredProducts = products
                                .where((product) => product.title
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                  ),
                  tSizedBoxHeight20,
                  isSearching
                      ? Column(
                          children: [
                            ...filteredProducts.map((product) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading:
                                        Image.network(product.imageurls[0]),
                                    title: Text(product.title),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductViewScreen(
                                                    product: product),
                                          ));
                                    },
                                  ),
                                )),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return threeDTextbutton(
                                  text: categories[index],
                                  onPress: () async {
                                    final tProducts = products
                                        .where((product) =>
                                            product.category ==
                                            categories[index])
                                        .toList();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(
                                                    categoryName:
                                                        categories[index],
                                                    products: tProducts)));
                                  });
                            },
                            separatorBuilder: (context, index) {
                              return tSizedBoxWidth20;
                            },
                            itemCount: categories.length,
                          ),
                        ),
                  tSizedBoxHeight20,
                  homeHeadings(text: "Recently added"),

                  StreamBuilder(
                      stream: ProductService().getNewlyAddedProductsStream(),
                      builder: (context, snapshot) =>
                          HomeHorizontalListviewWidget(
                              tSize: tSize, products: snapshot.data)),
                  // tSizedBoxHeight10,

                  StreamBuilder(
                    stream: ProductService().getPopularItemsStream(80),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            homeHeadings(text: "Popular"),
                            tSizedBoxHeight10,
                            HomeHorizontalListviewWidget(
                                tSize: tSize, products: snapshot.data),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),

                  StreamBuilder(
                    stream: wishlistListProductsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return snapshot.data!.isEmpty
                          ? const SizedBox(
                              height: 2,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: homeHeadings(text: "Your Wishlist"),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const WishlistScreen(),
                                    ));
                                  },
                                ),
                                tSizedBoxHeight10,
                                StreamBuilder<List<Product>>(
                                  stream: wishlistListProductsStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return HomeHorizontalListviewWidget(
                                        tSize: tSize, products: snapshot.data);
                                  },
                                ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
