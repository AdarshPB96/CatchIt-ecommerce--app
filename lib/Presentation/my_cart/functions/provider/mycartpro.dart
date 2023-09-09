import 'package:catch_it_project/core/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/cart_model.dart';
class CartPro extends ChangeNotifier {
   int? selectedQuantity;
  CollectionReference cartRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("cart");

  Future<Map<String, Product>> getProductMap() async {
    Map<String, Product> productMap = {};
    QuerySnapshot cartSnapshot = await cartRef.get();
    List<String> cartItemIds = cartSnapshot.docs.map((doc) => doc.id).toList();
     if (cartItemIds.isEmpty) {
    return productMap;
  }
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: cartItemIds)
        .get();

    for (var document in productSnapshot.docs) {
      Product product = Product.fromFirestore(document);
      productMap[document.id] = product;
    }

    return productMap;
  }



  Stream<List<Cart>> getCartDetailsStream() {
  return cartRef.snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((document) {
      return Cart.fromFirestore(document);
    }).toList();
  });
}
  Future<List<Cart>> getCartDetails() async {
    QuerySnapshot cartSnapshot = await cartRef.get();
    List<Cart> cartItemList = [];
    for (var document in cartSnapshot.docs) {
      Cart cartItem = Cart.fromFirestore(document);
 
      cartItemList.add(cartItem);
    }
    return cartItemList;
  }

  Future<void> getselectedQuantity({
    required int quantity,
    required String cartItemId,
    required String productPrice,
  }) async {
    selectedQuantity = quantity;

   
    double newPrice = double.parse(productPrice) * quantity;

  
    try {
      final cartDocRef = cartRef.doc(cartItemId);

      await cartDocRef.update({
        "quantity": quantity,
        "totalprice": newPrice.toString(),
      });

      notifyListeners();
    } catch (error) {
      print("Error updating Firestore document: $error");
    
    }
  }



  Future<List<String>> getCartProductIds() async {
    QuerySnapshot cartSnapshot = await cartRef.get();
    List<String> cartItemIds = cartSnapshot.docs.map((doc) => doc.id).toList();
    return cartItemIds;
  }

  getProductForcartPage() async {
    print('Fetching cart items...');
    QuerySnapshot cartSnapshot = await cartRef.get();
    List<String> cartItemIds = cartSnapshot.docs.map((doc) => doc.id).toList();
    print('Cart Item IDs: $cartItemIds');

    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: cartItemIds)
        .get();
    print('Product Snapshot: $productSnapshot');


  }

  void updateCartItem(String productId, int newQuantity, double newTotalPrice) {
   
    DocumentReference cartItemRef = cartRef.doc(productId);

   
    cartItemRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
      
        cartItemRef.update({
          'quantity': newQuantity.toString(),
          'totalprice': newTotalPrice.toString(),
        });
      }

    });
  }

  void increaseQuantityAndTotalPrice(String productId, Product product) {
 
    DocumentReference cartItemRef = cartRef.doc(productId);

    cartItemRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Cart cartItem = Cart.fromFirestore(docSnapshot);

        int newQuantity = int.parse(cartItem.quantity) + 1;
        double newTotalPrice = double.parse(product.price) * newQuantity;

   
        updateCartItem(productId, newQuantity, newTotalPrice);
      }
    });
  }

  Future<void> deleteFromCart({required String productId}) async {
    try {
      await cartRef.doc(productId).delete();
      notifyListeners();
    } catch (error) {
      // Handle error
      print("Error deleting cart item: $error");
      throw error;
    }
  }

  Future<double> getTotalCartValue() async {
    List<Cart> cartItemList =
        await getCartDetails(); 
    double totalValue = 0.0;
    for (Cart cartItem in cartItemList) {
      double cartTotalPrice = double.tryParse(cartItem.totalprice) ?? 0.0;
      totalValue += cartTotalPrice;
    }

    return totalValue;
  }
  Future<bool> isAlready({required String productId}) async {
  DocumentSnapshot cartItemSnapshot = await cartRef.doc(productId).get();
  return cartItemSnapshot.exists;
}

  Future<void> addToCart(
      {required String productId, required String price}) async {
    bool isProductInCart = await isAlready(productId: productId);

    if (isProductInCart) {
      return; // Product already in cart
    } else {
      double numericPrice = double.tryParse(price) ?? 0.0;
      int quantity = 1; // You can set the initial quantity here

      Cart newCartItem = Cart(
          productId: productId,
          quantity: quantity.toString(),
          totalprice: (numericPrice * quantity).toString());

      cartRef.doc(productId).set(newCartItem.toFirestore());
      notifyListeners();
    }
  }

  void updateCartQuantity(String catItemId, int quantity) async {
    DocumentReference cartDocRef = cartRef.doc(catItemId);

    try {
      DocumentSnapshot cartDoc = await cartDocRef.get();
      if (cartDoc.exists) {
        await cartDocRef.update({
          'quantity': quantity.toString(),
        });

        print('Cart quantity updated successfully.');
      } else {
        print('Cart item not found.');
      }
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }
}
