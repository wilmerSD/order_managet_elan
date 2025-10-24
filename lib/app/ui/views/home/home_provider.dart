import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_manager/app/models/repository/repository_general.dart';
import 'package:order_manager/app/models/response/response_list_order.dart';
import 'package:order_manager/core/helpers/custom_snackbar.dart';
import 'package:order_manager/core/theme/app_colors.dart';

class HomeController with ChangeNotifier {
  //INSTANCIA
  RepositoryGeneral orderRepository = RepositoryGeneral();

  String nroOrder = 'Todos';
  List<String> listNroOrders = ["Todos"];

  List<String> listPreparingFor = [
    "Preparar",
    "Preparando por amarillo",
    'Preparando por verde',
    'Preparando por azul',
    'Preparando por rojo',
  ];
  Map<int, String?> _preparingForMap = {};

  String? getPreparingFor(int orderId) => _preparingForMap[orderId];

  void updatePreparingFor(int orderId, String? value) {
    _preparingForMap[orderId] = value;
    notifyListeners();
  }

  List<ResponseListOrder> _listOrders = [];
  List<ResponseListOrder> listOrdersOriginal = [];
  set listOrders(List<ResponseListOrder> value) {
    _listOrders = value;
    notifyListeners();
  }

  String mapDropdownValueToOrderStatus(String? value) {
    if (value == null) return 'completed'; // valor por defecto si es nulo

    switch (value) {
      case 'Preparar':
        return 'processing';
      case 'Preparando por amarillo':
        return 'prepamarillo';
      case 'Preparando por verde':
        return 'prepverde';
      case 'Preparando por azul':
        return 'prepazul';
      case 'Preparando por rojo':
        return 'preprojo';
      default:
        return 'completed';
    }
  }

  final Map<String, String> statusToDropdown = {
    'preparar': 'Preparar',
    'prepamarillo': 'Preparando por amarillo',
    'prepverde': 'Preparando por verde',
    'prepazul': 'Preparando por azul',
    'preprojo': 'Preparando por rojo',
    'processing': 'Preparar', // Estado desde el backend
    'completed': 'Preparar', // por si acaso
  };

  void initDropdownForOrder(int orderId, String? status) {
    _preparingForMap[orderId] ??= getDropdownLabelFromStatus(status);
  }

  String getDropdownLabelFromStatus(String? status) {
    return statusToDropdown[status?.toLowerCase() ?? ''] ?? 'Preparar';
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
      listOrdersOriginal.addAll(toAdd);
      // --- Evitar duplicados en listNroOrders ---
      final existingNroOrders = listNroOrders.toSet(); // valores en String
      final toAddNroOrders = response
          .map((o) => (o.id ?? 0).toString())
          .where((idStr) => !existingNroOrders.contains(idStr));
      listNroOrders.addAll(toAddNroOrders);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> getOrderCompleted(BuildContext context) async {
    listOrders = [];
    listNroOrders = ["Todos"];
    isGettingListOrders = true;

    try {
      final response = await orderRepository.getOrderCompleted('completed');
      listOrders = response;
      listOrdersOriginal = List<ResponseListOrder>.from(listOrders);
      listNroOrders.addAll(
        listOrders.map((order) => (order.id ?? 0).toString()),
      );
      // getJustRestaurant(filterType: selectedFilter);
    } catch (e) {
      print(e);
    } finally {
      isGettingListOrders = false;
    }
  }

  Future<void> getOrderProcessingv1(BuildContext context, String status) async {
    listOrders = [];
    listNroOrders = ["Todos"];
    isGettingListOrders = true;

    try {
      final result = await orderRepository.getOrderProcessingv1(status);
      listOrders = result.orders;
      if (listOrders.isNotEmpty) {
        listOrders.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        listOrdersOriginal = List<ResponseListOrder>.from(listOrders);
        listNroOrders.addAll(
          listOrders.map((order) => (order.id ?? 0).toString()),
        );
        getJustRestaurant(filterType: selectedFilter);
      }

      // orderTotalProcessing = result.total;
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
    if (orderTotalProcessing < 100) {
      //estaba con 20
      final pedidoMap = newOrder as Map<String, dynamic>;
      final nuevoPedido = ResponseListOrder.fromJson(pedidoMap);
      if (nuevoPedido.status == 'processing') {
        listOrders.add(nuevoPedido);
        listOrdersOriginal.add(nuevoPedido);
        orderTotalProcessing += 1;
        listNroOrders.add((nuevoPedido.id ?? 0).toString());
        getJustRestaurant();
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

  Future<bool> postUpdateOrder(int orderId, String status) async {
    isUpdatingOrder = true;
    try {
      final response = await orderRepository.postUpdateOrder(orderId, status);
      if (response.status == status) {
        if (status == 'completed') {
          orderTotalProcessing -= 1;
          listOrders.removeWhere((order) => order.id == orderId);
          listOrdersOriginal.removeWhere((order) => order.id == orderId);
          listNroOrders.remove(orderId.toString());
        }
        // if (nroOrder == 'Todos') {
        //   getOrderProcessing(
        //     'processing,prepamarillo,prepverde,prepazul,preprojo',
        //   );
        // }
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

  void updateOrRemoveOrderFromList(int orderId, String status) {
    final index = listOrders.indexWhere((order) => order.id == orderId);

    if (status == 'completed') {
      // 1. obtener el id del pedido antes de eliminarlo de listOrders
      final orderIdToRemove = listOrders[index].id;

      orderTotalProcessing -= 1;
      // 2. eliminar de listOrders
      listOrders.removeAt(index);

      // eliminar de la lista original usando id (NO por index)
      // listOrdersOriginal.removeAt(index);
      listOrdersOriginal.removeWhere((order) => order.id == orderId);

      // 3. eliminar de listNroOrders por valor (conversión a string)
      listNroOrders.remove(orderIdToRemove?.toString());

      // listOrders.removeWhere((order) => order.id == orderId);
    } else {
      listOrders[index].status = status;

      // buscar y actualizar en listOrdersOriginal también
      final originalIndex = listOrdersOriginal.indexWhere(
        (order) => order.id == orderId,
      );
      if (originalIndex != -1) {
        listOrdersOriginal[originalIndex].status = status;
      }
      _preparingForMap[orderId] = getDropdownLabelFromStatus(
        status,
      ); // ✅ ACTUALIZAR también el valor del dropdown
    }
    notifyListeners();
  }

  final Map<String, Color> preparingColorMap = {
    'Preparar': const Color.fromRGBO(37, 167, 190, 100),
    'Preparando por amarillo': const Color.fromRGBO(255, 229, 125, 1),
    'Preparando por verde': const Color.fromRGBO(166, 221, 91, 1),
    'Preparando por azul': const Color.fromRGBO(120, 206, 224, 1),
    'Preparando por rojo': const Color.fromRGBO(255, 99, 125, 1),
  };

  Color getDropdownColor(String? label) {
    return preparingColorMap[label] ?? Colors.grey;
  }

  List<ResponseListOrder> listOrdersCopy = [];

  void getJustRestaurant({String filterType = 'all'}) {
    // Guardamos la lista original la primera vez (para poder restaurarla)
    if (listOrdersCopy.isEmpty) {
      listOrdersCopy = List.from(listOrders);
    }

    // Filtramos según el tipo de filtro
    switch (filterType) {
      case 'menu': // solo los que tienen Menú
        // listOrdersCopy =
        //     listOrders.where((order) {
        //       final menuName = getMenuName(order.lineItems!);
        //       return menuName.startsWith('Menú') || menuName.startsWith('menú');
        //     }).toList();
        listOrders =
            listOrdersCopy.where((order) {
              final menuName = getMenuName(order.lineItems!);
              return (menuName.startsWith('Menú') || menuName.startsWith('menú') || menuName.startsWith('Carta') || menuName.startsWith('carta'));
            }).toList();
        break;

      case 'no_menu': // solo los que NO tienen Menú
        // listOrdersCopy =
        //     listOrders.where((order) {
        //       final menuName = getMenuName(order.lineItems!);
        //       return !(menuName.startsWith('Menú') ||
        //           menuName.startsWith('menú'));
        //     }).toList();
        listOrders =
            listOrdersCopy.where((order) {
              final menuName = getMenuName(order.lineItems!);
              return !(menuName.startsWith('Menú') ||
                  menuName.startsWith('menú') || menuName.startsWith('Carta') || menuName.startsWith('carta'));
            }).toList();
        break;

      case 'all': // todos
      default:
        listOrders = List.from(listOrdersCopy);
        // listOrdersCopy = List.from(listOrders);
        break;
    }
    orderTotalProcessing = listOrders.length;
    notifyListeners();
  }

  // /// Devuelve el nombre del primer item que empieza con "Menú", o '' si no hay
  // String getMenuName(List<LineItem> lineItems) {
  //   final found = lineItems.firstWhere(
  //     (item) =>
  //         item.name != null &&
  //         item.name!.trim().toLowerCase().startsWith('menú'),
  //     orElse: () => LineItem(name: ''),
  //   );
  //   return found.name ?? '';
  // }

  /// Devuelve el nombre del primer item que empieza con "Menú" o "Carta", o '' si no hay
  String getMenuName(List<LineItem> lineItems) {
    final found = lineItems.firstWhere(
      (item) {
        if (item.name == null) return false;
        final name = item.name!.trim().toLowerCase();
        return name.startsWith('menú') || name.startsWith('carta');
      },
      orElse: () => LineItem(name: ''),
    );
    return found.name ?? '';
  }


  // void filterNroOrder(String? nroOrder) {
  //   if (nroOrder != null) {
  //     this.nroOrder = nroOrder;
  //     if (nroOrder == 'Todos') {
  //       // Si es "Todos", mostrar todos los pedidos
  //       listOrders = List<ResponseListOrder>.from(listOrdersOriginal);
  //     } else {
  //       // Filtrar por el número de pedido seleccionado
  //       listOrders = listOrdersOriginal
  //           .where((order) => (order.id ?? 0).toString() == nroOrder)
  //           .toList();
  //     }
  //   }
  //   notifyListeners();
  // }
  void filterNroOrder(String? nroOrder) {
    this.nroOrder = nroOrder ?? 'Todos';

    if (this.nroOrder == 'Todos') {
      // Mostrar todos los pedidos desde la lista original
      listOrders = [...listOrdersOriginal];
    } else {
      // Filtrar por el número de pedido seleccionado
      listOrders =
          listOrdersOriginal
              .where((order) => (order.id ?? 0).toString() == this.nroOrder)
              .toList();
    }
  }

  String _selectedFilter = 'all';
  String get selectedFilter => _selectedFilter;

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    getJustRestaurant(filterType: filter);
    notifyListeners();
  }
}
