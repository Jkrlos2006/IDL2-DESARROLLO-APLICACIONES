import 'package:flutter/material.dart';
import 'product_page.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart';
import 'cart_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        home: ProductPage(),
        routes: {
          '/cart': (context) => CartPage(),
        },
      ),
    );
  }
}
