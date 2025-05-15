import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:order_manager/app/models/response/order_response.dart';
import 'package:order_manager/app/models/response/response_list_order.dart';

class RepositoryGeneral {
  final String consumerKey =
      'ck_51146f79d10632467febf6b596c8acdb04491caf'; // reemplaza con tu clave real
  final String consumerSecret =
      'cs_065f008621c17d24f9ef8ef2f6d685c59eda517a'; // reemplaza con tu clave real

  Future<List<ResponseListOrder>> getOrderCompleted(String status) async {
    final url = Uri.parse(
      'https://elan.pe/wp-json/wc/v3/orders?status=$status&perPage=20,&consumer_key=$consumerKey&consumer_secret=$consumerSecret',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ResponseListOrder.fromJson(json)).toList();
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<ResponseListOrder>> getOrderProcessing(String status) async {
    final url = Uri.parse(
      'https://elan.pe/wp-json/wc/v3/orders?status=$status&order=asc&per_page=20&consumer_key=$consumerKey&consumer_secret=$consumerSecret',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ResponseListOrder.fromJson(json)).toList();
      /* final data = jsonDecode(response.body);
    return (data as List)
        .map((json) => ResponseListOrder.fromJson(json))
        .toList(); */
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<OrderResponse> getOrderProcessingv1(String status) async {
    final url = Uri.parse(
      'https://elan.pe/wp-json/wc/v3/orders?status=$status&order=asc&per_page=20&consumer_key=$consumerKey&consumer_secret=$consumerSecret',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final total = int.tryParse(response.headers['x-wp-total'] ?? '0') ?? 0;
      final List<dynamic> data = jsonDecode(response.body);
      final orders =
          data.map((json) => ResponseListOrder.fromJson(json)).toList();

      return OrderResponse(orders: orders, total: total);
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResponseListOrder> postUpdateOrder(int orderId) async {
    final url = Uri.parse(
      'https://elan.pe/wp-json/wc/v3/orders/$orderId?per_page=20&consumer_key=$consumerKey&consumer_secret=$consumerSecret',
    );

    final response = await http.post(url, body: {"status": "completed"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResponseListOrder.fromJson(data);
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
