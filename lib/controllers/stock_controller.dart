import 'dart:convert';
import 'package:konter_hp/models/stock_model.dart';
import 'package:http/http.dart' as http;

class StockController {
  final String url = 'https://api.kartel.dev/stocks';

  Future<List<Stock>> fetchStocks() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Stock> stocks = data.map((json) => Stock.fromJson(json)).toList();
      return stocks;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<http.Response> postData(
    {required String name,
    required int qty,
    required String attr,
    required int weight,
    required String issuer}) async {
    var response = await http.post(Uri.parse(url), 
    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({
      'name': name,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'issuer': issuer,
    }));

    return response;
  }

  Future<http.Response> updateStock(
    {required String id,
    required String name,
    required int qty,
    required String attr,
    required int weight,
    required String issuer}) async {
    var response = await http.put(Uri.parse('$url/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'issuer': issuer,
    }));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update stock');
    }
  }

  Future<void> deleteStock(String id) async {
    var response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode != 204){
      throw Exception('Failed to delete stock:$id');
    }
  }
}
