import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:order_manager/app/models/repository/repository_general.dart';
import 'package:order_manager/app/models/response/response_list_order.dart';

class HomeController with ChangeNotifier {
  //INSTANCIA
  RepositoryGeneral orderRepository = RepositoryGeneral();

  //VARIABLES
  List<ResponseListOrder> listOrders = [];
  ResponseListOrder ordersObject = ResponseListOrder();

  String _fullName = '';
  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get fullName => _fullName;

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
  Future<void> obtenerPedidosPendientes() async {
    isGettingListOrders = true;
    try {
      final response = await orderRepository.getPedidosPendientes();

      if (response.isEmpty) {
        /*  CustomSnackbar.showSnackBarSuccess(
      context,
      title: "Pedidos",
      message: "No hay pedidos pendientes por ahora",
    ); */
        // return;
      }
      listOrders = response;
      /* print(listOrders);
      listOrders.map((order) {
        debugPrint("hola1");
        final customerName = order.billing?.firstName ?? 'Sin nombre';
        final customerLastName = order.billing?.lastName ?? '';
        final items = order.lineItems ?? [];
        print(items.length);
        debugPrint(items.toString());
      }); */
      // Aquí puedes usar `pedidos` directamente para mostrar en pantalla
    } catch (e) {
      print(e);
      /*  CustomSnackbar.showSnackBarSuccess(
    context,
    title: "Error",
    message: "No se pudieron obtener los pedidos: $e",
  ); */
    } finally {
      isGettingListOrders = false;
      notifyListeners();
    }
  }
}
