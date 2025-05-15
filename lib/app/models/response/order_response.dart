import 'package:order_manager/app/models/response/response_list_order.dart';

class OrderResponse {
  final List<ResponseListOrder> orders;
  final int total;

  OrderResponse({required this.orders, required this.total});
}