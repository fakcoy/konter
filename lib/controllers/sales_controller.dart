import 'dart:convert';

import 'package:konter_hp/models/sales_model.dart';
import 'package:http/http.dart' as http;

class saleController {
  final String url = 'https://api.kartel.dev/sales';

  Future<List<Sales>> fetchsales() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Sales> sales = data.map((json) => Sales.fromJson(json)).toList();
      return sales;
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<http.Response> postData(
      {required String buyer,
      required String phone,
      required String date,
      required String status,
      required String issuer}) async {
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'buyer': buyer,
          'phone': phone,
          'date': date,
          'status': status,
          'issuer': issuer,
        }));

    return response;
  }

  Future<http.Response> updatesale(
      {required String id,
      required String buyer,
      required String phone,
      required String date,
      required String status,
      required String issuer}) async {
    var response = await http.put(Uri.parse('$url/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'buyer': buyer,
          'phone': phone,
          'date': date,
          'status': status,
          'issuer': issuer,
        }));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update sale');
    }
  }

  Future<void> deletesale(String id) async {
    var response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale:$id');
    }
  }
}
