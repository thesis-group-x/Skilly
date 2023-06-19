import 'package:client/market/components/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  Stripe.publishableKey =
      'pk_test_51NJi2oFuE67mowKS98uhEQ3BmNa6FLxQLoGeVaFmGOYnzTqqD9TvGeE3zg00qbE8d3aJlBzMerK47fc4ZkO6HWRb00NGxnL4o9';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SkillyApp());
}

class SkillyApp extends StatelessWidget {
  const SkillyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skilly',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
