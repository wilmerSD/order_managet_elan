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

  List<ResponseListOrder> get listOrders => _listOrders;

  ResponseListOrder ordersObject = ResponseListOrder();

  String _fullName = '';
  int _optionOrders = 0;
  set optionOrders(int value){
    _optionOrders = value;
    notifyListeners();
  }
  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }
  String get fullName => _fullName;
  int get optionOrders => _optionOrders;

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
  

  Future<void> getOrderProcessing(BuildContext context, String status) async {
    listOrders = [];
    isGettingListOrders = true;
    try {
      final response = await orderRepository.getOrderProcessing(status);
      listOrders = response;
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

  bool _isUpdatingOrder = false;
  set isUpdatingOrder(bool value) {
    _isUpdatingOrder = value;
    notifyListeners();
  }

  bool get isUpdatingOrder => _isUpdatingOrder;
  Future<void> postUpdateOrder(int orderId) async {
    isUpdatingOrder = true;
    try {
      final response = await orderRepository.postUpdateOrder(orderId);
      if (response.status == 'completed') {
        listOrders.removeWhere((order) => order.id == orderId);
      }
    } catch (e) {
      print(e);
    } finally {
      isUpdatingOrder = false;
    }
  }
}
