import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:order_manager/app/models/repository/repository_general.dart';
import 'package:order_manager/app/models/response/response_list_order.dart';
import 'package:order_manager/core/helpers/custom_snackbar.dart';
import 'package:order_manager/core/theme/app_colors.dart';

class HomeController with ChangeNotifier {
  //INSTANCIA
  RepositoryGeneral orderRepository = RepositoryGeneral();

  //VARIABLES
  List<ResponseListOrder> _listOrders = [];
  set listOrders(List<ResponseListOrder> value) {
    _listOrders = value;
    notifyListeners();
  }

  Map<int, bool> _loadingOrders = {};

  bool isOrderLoading(int orderId) => _loadingOrders[orderId] ?? false;

  void setOrderLoading(int orderId, bool isLoading) {
    _loadingOrders[orderId] = isLoading;
    notifyListeners();
  }

  List<ResponseListOrder> get listOrders => _listOrders;

  ResponseListOrder ordersObject = ResponseListOrder();

  String _fullName = '';
  int _optionOrders = 0;
  int _orderTotalProcessing = 0;
  set optionOrders(int value) {
    _optionOrders = value;
    notifyListeners();
  }

  set orderTotalProcessing(int value) {
    _orderTotalProcessing = value;
    notifyListeners();
  }

  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get fullName => _fullName;
  int get optionOrders => _optionOrders;
  int get orderTotalProcessing => _orderTotalProcessing;

  //FUNCIONES
  late Timer timer;
  String _currentTime = '';

  timeProvider() {
    _currentTime = _getCurrentTime();
    _startTimer();
  }

  // Inicia el temporizador y actualiza la hora cada segundo
  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _currentTime = _getCurrentTime();
      notifyListeners(); // Notifica a los listeners para que se reconstruyan
    });
  }

  // Función para obtener la hora actual
  String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  // Obtiene la hora formateada
  String get currentTime => _currentTime;

  bool _isGettingListOrders = false;

  set isGettingListOrders(bool value) {
    _isGettingListOrders = value;
    notifyListeners();
  }

  bool get isGettingListOrders => _isGettingListOrders;

  Future<void> getOrderProcessing(String status) async {
    try {
      final response = await orderRepository.getOrderProcessing(status);
      final existingIds =
          listOrders
              .map((o) => o.id)
              .toSet(); // Filtrar solo los que no están ya en la lista
      final toAdd = response.where((order) => !existingIds.contains(order.id));
      listOrders.addAll(toAdd);
    } catch (e) {
      print(e);
    } finally {} 
  }

  Future<void> getOrderCompleted(BuildContext context, String status) async {
    listOrders = [];
    isGettingListOrders = true;

    try {
      final response = await orderRepository.getOrderCompleted(status);
      listOrders = response;
    } catch (e) {
      print(e);
    } finally {
      isGettingListOrders = false;
    }
  }

  Future<void> getOrderProcessingv1(BuildContext context, String status) async {
    listOrders = [];
    isGettingListOrders = true;

    try {
      final result = await orderRepository.getOrderProcessingv1(status);
      listOrders = result.orders;
      if (listOrders.isNotEmpty) {
        listOrders.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      }

      orderTotalProcessing = result.total;
    } catch (e) {
      CustomSnackbar.showSnackBarCustom(
        context,
        title: "Error",
        message: "Ups... No se pudieron obtener los pedidos: $e",
        color: AppColors.errorColor,
      );
    } finally {
      isGettingListOrders = false;
    }
  }

  void listenNewOrder(newOrder) async {
    if (orderTotalProcessing < 20) {
      final pedidoMap = newOrder as Map<String, dynamic>;
      final nuevoPedido = ResponseListOrder.fromJson(pedidoMap);
      if (nuevoPedido.status == 'processing'){
        listOrders.add(nuevoPedido);
        orderTotalProcessing += 1;
      }
    }
  }

  bool _isOrderDelivered = false;
  bool _isUpdatingOrder = false;

  set isUpdatingOrder(bool value) {
    _isUpdatingOrder = value;
    notifyListeners();
  }

  set isOrderDelivered(bool value) {
    _isOrderDelivered = value;
    notifyListeners();
  }

  bool get isOrderDelivered => _isOrderDelivered;
  bool get isUpdatingOrder => _isUpdatingOrder;

  Future<bool> postUpdateOrder(int orderId) async {
    isUpdatingOrder = true;
    try {
      final response = await orderRepository.postUpdateOrder(orderId);
      if (response.status == 'completed') {
        listOrders.removeWhere((order) => order.id == orderId);
        getOrderProcessing('processing');
        orderTotalProcessing -= 1;
        return true;
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingOrders.remove(orderId);
      isUpdatingOrder = false;
    }
    return false;
  }

  void removeOrderFromList(int orderId) {
    orderTotalProcessing -= 1;
    listOrders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}
