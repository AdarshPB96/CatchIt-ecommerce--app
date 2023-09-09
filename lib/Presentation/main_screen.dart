import 'package:catch_it_project/Presentation/home/home_screen.dart';
import 'package:catch_it_project/Presentation/more/more_screen.dart';
import 'package:catch_it_project/Presentation/my_cart/my_cart_screen.dart';
import 'package:catch_it_project/Presentation/my_list/my_list_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final _pages =  [
    HomePage(),
    const MyListScreen(),
    const MyCartScreen(),
    MoreScreen()
  ];

 final ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int index, child) {
          return _pages[index];
        },
      )),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int index, child) {
          return BottomNavigationBar(
              currentIndex: index,
              onTap: (index) {
                indexChangeNotifier.value = index;
              },
              backgroundColor: Colors.black,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.fact_check), label: "My List"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    label: "My Cart"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.density_small), label: "More")
              ]);
        },
      ),
    );
  }
}
