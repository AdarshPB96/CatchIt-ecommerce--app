import 'dart:developer';
import 'package:catch_it_project/Presentation/main_screen.dart';
import 'package:catch_it_project/Presentation/payment_screen/provider/order_provider.dart';
import 'package:catch_it_project/core/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderPaymentScreen extends StatefulWidget {
 final List<Cart> cartItems;
 final String totalAmount;

  const OrderPaymentScreen(
      {required this.cartItems, required this.totalAmount, super.key});

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay!.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final tpro = Provider.of<OrderProvider>(context, listen: false);
    tpro.createOrderAndDeleteCartItems(
        paymentId: response.paymentId!,
        cartItems: widget.cartItems,
        totalAmount: widget.totalAmount);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );

    print("Success..........................");
    _proceedToOrderSection(response.paymentId.toString());
    Fluttertoast.showToast(msg: "Order placed", fontSize: 16.0);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed, handle the error accordingly
    print("Payment Error..........................");
    // Show an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Failed"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String? paymentId;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryPage(paymentId: paymentId.toString()),
      ),
    );

    // Handle external wallet selection if needed
    print("External Wallet..........................");
  }

  void openCheckOut() async {
    final user = FirebaseAuth.instance.currentUser;
    double totalAmount = double.parse(widget.totalAmount);
    var options = {
      'key': 'rzp_test_HWcSM8NC9gwoqJ',
      'amount': totalAmount*100,
      'name': 'Catch It.',
      'description': 'Item',
      // 'retry': {'enabled': true, 'max_count': 1},
      // 'send_sms_hash': true,
      'prefill': {'contact': '', 'email': '${user!.email}'},
      // 'external': {
      //   'wallets': ['paytm']
      // },
      // 'payment_capture': '1',
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  void _proceedToOrderSection(String paymentId) {
    // Here, you can proceed with creating an order or any other relevant action
    // based on the successful payment
    // Example: Navigate to the order summary page with the payment details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Payment Page"),
      // ),
      body: Center(
        child: ElevatedButton(
          onPressed: openCheckOut,
          child: const Text("Pay Now"),
        ),
      ),
    );
  }
}

class OrderSummaryPage extends StatelessWidget {
  final String paymentId;

  const OrderSummaryPage({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Payment Successful!"),
            const SizedBox(height: 16),
            Text("Payment ID: $paymentId"),
          ],
        ),
      ),
    );
  }
}
