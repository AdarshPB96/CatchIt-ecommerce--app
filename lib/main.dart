
import 'package:catch_it_project/Presentation/address_add_screen/provider/address_provider.dart';
import 'package:catch_it_project/Presentation/more/provider/account_provider.dart';
import 'package:catch_it_project/Presentation/my_cart/functions/provider/mycartpro.dart';
import 'package:catch_it_project/Presentation/payment_screen/provider/order_provider.dart';
import 'package:catch_it_project/Presentation/product_view/provider/wishlist_provider.dart';
import 'package:catch_it_project/Presentation/splash_screen.dart';
import 'package:catch_it_project/domain/provider/signIn_provider.dart';
import 'package:catch_it_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignInPro(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistPro(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistPro(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartPro(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressPro(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          ),
        ChangeNotifierProvider(
          create: (context) => AccountPro(),
          )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.green,
              textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.blue),
                  bodyMedium: TextStyle(color: Colors.blue),
                  bodySmall: TextStyle(
                    color: Colors.blue,
                  ))),
          home: SplashScreen()),
    );
  }
}
