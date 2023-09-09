import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:catch_it_project/core/models/product.dart';

class OrderService {


  Map<Product, String> getOrderProductsDetails(
      List<Cart> cartItems, Map<String, Product> productMap) {
    Map<Product, String> orderedProducts = {};

    for (Cart cartItem in cartItems) {
      Product product = productMap[cartItem.productId]!;
      orderedProducts[product] = cartItem.quantity.toString();
    }

    return orderedProducts;
  }
}
