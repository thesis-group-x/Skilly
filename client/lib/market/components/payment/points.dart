import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  Stripe.publishableKey =
      'pk_test_51NJi2oFuE67mowKS98uhEQ3BmNa6FLxQLoGeVaFmGOYnzTqqD9TvGeE3zg00qbE8d3aJlBzMerK47fc4ZkO6HWRb00NGxnL4o9';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            makepayment("100", "INR");
          },
          child: Text("Pay"),
        ),
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makepayment(String amount, String currency) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      print(paymentIntentData);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                // applePay: true,
                googlePay: PaymentSheetGooglePay(merchantCountryCode: 'IN'),
                merchantDisplayName: "Prospects",
                customerId: paymentIntentData!['customer'],
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                customerEphemeralKeySecret:
                    paymentIntentData!['ephemeralkey']));
        displayPaymentSheet();
      }
    } catch (e, s) {
      print("EXCEPTION ===$e$s");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization':
                "Bearer sk_test_51NJi2oFuE67mowKSlRn8ryRmofwMCCUNHzSCstl2wYXQJ0lKN5ocL33v1saQtHK3j1Oncv4Bx3h95LT8PZ7UD3ME00HvxiYhq2",
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print(response);
      return jsonDecode(response.body);
    } catch (err) {
      print("err charging user $err");
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar("Payment info", "pay successful");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("error from stripe $e");
      } else {
        print("Unforeseen error $e");
      }
    } catch (e) {
      print("exception===$e");
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
