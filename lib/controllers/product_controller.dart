import 'dart:convert';

import 'package:konter_hp/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductController {
  final String url = 'https://api.kartel.dev/products';

  Future<List<Product>> fetchProducts() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Product> products = data.map((json) => Product.fromJson(json)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<http.Response> postData(
    {required String name,
    required num price,
    required num qty,
    required String attr,
    required num weight,
    required String issuer}) async {
    var response = await http.post(Uri.parse(url), 
    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({
      'name': name,
      'price': price,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'issuer': issuer,
    }));

    return response;
  }

  Future<http.Response> updateProduct(
    {required String id,
    required num price,
    required String name,
    required num qty,
    required String attr,
    required num weight,
    required String issuer}) async {
    var response = await http.put(Uri.parse('$url/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'price': price,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'issuer': issuer,
    }));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String id) async {
    var response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode != 204){
      throw Exception('Failed to delete product:$id');
    }
  }
}
