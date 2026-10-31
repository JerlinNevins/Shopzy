import 'dart:convert';

 import 'package:http/http.dart' as http;

 import '../models/product.dart';

 /// Data layer: the only place that talks to the REST API.
class ProductRepository {
   static const _url = 'https://fakestoreapi.com/products';

   Future<List<Product>> fetchAll() async {
   final res = await http
   .get(Uri.parse(_url))
   .timeout(const Duration(seconds: 15)); // don't spin forever offline
   if (res.statusCode != 200) {
   throw Exception('Could not load products (${res.statusCode})');
   }
   final list = jsonDecode(res.body) as List;
   return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
   }
   }