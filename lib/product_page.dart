import 'package:flutter/material.dart';
import 'product_controller.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'product.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController _productController = ProductController();
  List<Product> products = [];
  bool isSecondPageLoaded = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadProducts();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isSecondPageLoaded) {
        _loadNextProducts();
      }
    }
  }

  Future<void> _loadProducts() async {
    try {
      List<Product> fetchedProducts = await _productController.fetchProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadNextProducts() async {
    try {
      List<Product> fetchedNextProducts =
          await _productController.fetchNextProducts();
      setState(() {
        products.addAll(fetchedNextProducts);
        isSecondPageLoaded = true;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Bodega Digital',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 104, 10, 10),
        toolbarHeight: 60,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 104, 10, 10),
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: const Icon(Icons.shopping_bag),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final product = products[index];
            return Consumer<CartModel>(
              builder: (context, cart, child) {
                int quantity = cart.getProductQuantity(product);
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 90, 13, 13)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Image.asset(
                          "assets/images/image.png",
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Precio: S/ ${product.price.toString()}'),
                        Text('Stock: ${product.stock.toString()}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_sharp),
                              color: Color.fromARGB(255, 116, 7, 7),
                              iconSize: 30,
                              onPressed: () {
                                if (quantity > 0) {
                                  cart.decreaseProductQuantity(product);
                                }
                              },
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              icon: Icon(Icons.add_circle_sharp),
                              color: Color.fromARGB(255, 12, 87, 10),
                              iconSize: 30,
                              onPressed: () {
                                if (quantity < product.stock) {
                                  cart.increaseProductQuantity(product);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Stock Insuficiente"),
                                        content: Text(
                                            "Se excedió el límite de stock"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("ok"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
