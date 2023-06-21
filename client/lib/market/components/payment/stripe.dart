import 'dart:async';
import 'dart:convert';
import 'package:client/market/components/payment/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:client/market/components/payment/succ.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../utils/api.dart';
import 'animation.dart';
import 'succ.dart';

class PaymentPage extends StatefulWidget {
  final Pack pack;
  final String packId;

  const PaymentPage({Key? key, required this.pack, required this.packId})
      : super(key: key);

  // ...

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int activeCard = 0;
  bool _isLoading = false;
  // ignore: unused_field
  late Timer _timer;
  // ignore: unused_field
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      Stripe.publishableKey =
          'pk_test_51NJi2oFuE67mowKS98uhEQ3BmNa6FLxQLoGeVaFmGOYnzTqqD9TvGeE3zg00qbE8d3aJlBzMerK47fc4ZkO6HWRb00NGxnL4o9';
      _counter++;
    });
  }

  pay() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = const Duration(seconds: 2);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _isLoading = false;
          timer.cancel();
          makepayment(widget.pack.price.toInt() * 100, "USD");
        });
      },
    );
  }

  void navigateToSuccessPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccess(),
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makepayment(int amount, String currency) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      print(paymentIntentData);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
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

  createPaymentIntent(int amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
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

  Future<void> purchasePoints(int id, String uid) async {
    final endpoint =
        'http://${localhost}:3001/stripe/purchase/$uid'; // Construct the endpoint URL with the pack ID

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        body: json.encode({
          'packId': id,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Points purchased successfully: ${responseData['message']}');
      } else if (response.statusCode == 404) {
        print('Error: Pack not found');
      } else {
        print('Error purchasing points');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar("Payment info", "Payment successful");
      await purchasePoints(
          widget.pack.id, FirebaseAuth.instance.currentUser!.uid);
      navigateToSuccessPage(); // Navigate to the success page after payment and purchase completion
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

//in cents

//payment styling
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Payment',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                activeCard == 0
                    ? FadeAnimation(
                        1.2,
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: activeCard == 0 ? 1 : 0,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange,
                                    Colors.yellow.shade800,
                                    Colors.yellow.shade900,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Credit Card",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "**** **** **** 7890",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Skilly",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Image.network(
                                              'https://img.icons8.com/color/2x/mastercard-logo.png',
                                              height: 50),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        ))
                    : FadeAnimation(
                        1.2,
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: activeCard == 1 ? 1 : 0,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            padding: EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                // color: Colors.grey.shade200
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade200,
                                    Colors.grey.shade100,
                                    Colors.grey.shade200,
                                    Colors.grey.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                          'https://img.icons8.com/ios/2x/mac-os.png',
                                          height: 50),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Skilly",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          Image.network(
                                            'https://img.icons8.com/ios/2x/sim-card-chip.png',
                                            height: 35,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        )),
                SizedBox(
                  height: 50,
                ),
                FadeAnimation(
                    1.2,
                    Text(
                      "Payment Method",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.3,
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeCard = 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: activeCard == 0
                                ? Border.all(
                                    color: Colors.grey.shade300, width: 1)
                                : Border.all(
                                    color: Colors.grey.shade300.withOpacity(0),
                                    width: 1),
                          ),
                          child: Image.network(
                            'https://img.icons8.com/color/2x/mastercard-logo.png',
                            height: 50,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeCard = 1;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: activeCard == 1
                                ? Border.all(
                                    color: Colors.grey.shade300, width: 1)
                                : Border.all(
                                    color: Colors.grey.shade300.withOpacity(0),
                                    width: 1),
                          ),
                          child: Image.network(
                            'https://img.icons8.com/ios-filled/2x/apple-pay.png',
                            height: 50,
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                  height: 30,
                ),
                FadeAnimation(
                    1.4,
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Offers",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                              onPressed: () {}, child: Text("Add a code"))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.5,
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text("E-75, Diamond Dis..."),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                  )
                                ],
                              ))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 100,
                ),
                FadeAnimation(
                    1.5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Payment",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text("\$ USD ${widget.pack.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    )),
                SizedBox(height: 30),
                FadeAnimation(
                  1.4,
                  MaterialButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            pay();
                          },
                    height: 50,
                    elevation: 0,
                    splashColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.yellow[800],
                    child: Center(
                      child: _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Pay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ));
  }
}
