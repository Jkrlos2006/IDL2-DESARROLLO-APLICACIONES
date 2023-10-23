import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController {
  final String apiUrl = 'https://shop-api-roan.vercel.app/product';
  final String apiUrlPage2 =
      'https://shop-api-roan.vercel.app/product?page=2&pageSize=10';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Product> products =
          body.map((dynamic item) => Product.fromJson(item)).toList();

      return products;
    } else {
      throw Exception("Error al cargar los productos");
    }
  }

  Future<List<Product>> fetchNextProducts() async {
    final response = await http.get(Uri.parse(apiUrlPage2));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Product> products =
          body.map((dynamic item) => Product.fromJson(item)).toList();

      return products;
    } else {
      throw Exception("Error al cargar los productos de la página 2");
    }
  }
}
