import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:order_manager/app/ui/components/button/btn_save_sec.dart';
import 'package:order_manager/app/ui/components/button/custom_dropdown_button.dart';
import 'package:order_manager/app/ui/views/home/home_provider.dart';
import 'package:order_manager/app/ui/views/home/widgets/appbar_home.dart';
import 'package:order_manager/app/ui/views/home/widgets/header_home.dart';
import 'package:order_manager/core/helpers/helpers.dart';
import 'package:order_manager/core/preferences/shared_preferences.dart';
import 'package:order_manager/core/preferences/theme_provider.dart';
import 'package:order_manager/core/service/sokect_service.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late SocketService socketService;
  final _controller = ScrollController();

  @override
  void initState() {
    socketService = SocketService();
    socketService.initSocket();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeController = Provider.of<HomeController>(
        context,
        listen: false,
      );

      homeController.timeProvider();
      homeController.getOrderProcessingv1(
        context,
        'processing,prepamarillo,prepverde,prepazul,preprojo',
      );
      socketService.socket.on('nuevo_pedido', (data) {
        homeController.listenNewOrder(data);//Evento desde woocomerce
      });

      socketService.socket.on('order_delivered_emit', (data) {
        try {
          final int id = int.parse(data['orderId'].toString());
          final String status = data['status'].toString();
          homeController.updateOrRemoveOrderFromList(id, status);
          homeController.getOrderProcessing(
            'processing,prepamarillo,prepverde,prepazul,preprojo',
          );
        } catch (e) {
          print('❌ Error al convertir orderId: $data');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final prefs = PreferencesUser();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            HeaderHome(),
            Expanded(
              child:
                  homeController.isGettingListOrders
                      ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryConst,
                        ),
                      )
                      : homeController.listOrders.isEmpty
                      ? Center(child: Text('Sin ordenes'))
                      : RawScrollbar(
                        controller: _controller,
                        thumbVisibility: true,
                        interactive: true,
                        pressDuration:
                            Duration
                                .zero, // 👈 arrastra al instante (sin long-press)
                        thickness: 8, // opcional: más fácil de agarrar
                        radius: const Radius.circular(8),
                        thumbColor:
                            AppColors.primaryConst, // 👈 color de la barrita
                        trackVisibility:
                            true, // 👈 opcional: mostrar la pista (fondo)
                        trackColor: Colors.grey.shade300,
                        child: MasonryGridView.count(
                          controller: _controller,
                          primary:
                              false, // 👈 evita que use el PrimaryScrollController del Scaffold
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          padding: const EdgeInsets.all(12.0),
                          itemCount: homeController.listOrders.length,
                          itemBuilder: (context, index) {
                            final order = homeController.listOrders[index];
                            final orderId = order.id ?? 0;
                            final customerName =
                                order.billing?.firstName ?? 'Sin nombre';
                            final orderNote =  order.customerNote?.isNotEmpty == true ? order.customerNote : 'Ninguno'; 
                            final customerLastName =
                                order.billing?.lastName ?? '';
                            final items = order.lineItems ?? [];
                            String status =
                                order.status ??
                                ''; // <-- viene de backend, ej: "prepazul"
                            homeController.initDropdownForOrder(
                              orderId,
                              status,
                            );
                            return ClipPath(
                              clipper: ZigZagClipper(),
                              child: Card(
                                color: AppColors.cardList(context),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 30.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'N° de pedido:',
                                              style: TextStyle(
                                                color: AppColors.black,
                                              ),
                                            ),
                                            Text(
                                              '${order.id}',
                                              style:
                                                  AppTextStyle(
                                                    context,
                                                  ).nroOrder(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      customSubTittle(
                                        'Cliente:',
                                        '$customerName $customerLastName',
                                      ),
                                      customSubTittleSec(
                                        'Fecha y hora:',
                                        Helpers.formatedDateTime(
                                          order.dateCreated,
                                        ),
                                      ),
                                      Text(
                                        'Productos',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textCardList(
                                            context,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      ...items.map((item) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              if (item.image?.src != null)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.0,
                                                      ),
                                                  child: Image.network(
                                                    item.image!.src!,
                                                    height: 40.0,
                                                    width: 40.0,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        height: 40.0,
                                                        width: 40.0,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade300,
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                          size: 20.0,
                                                          color: Colors.grey,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              else
                                                const SizedBox(
                                                  width: 40.0,
                                                  height: 40.0,
                                                ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.name ?? 'Sin nombre',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textCardList(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Cantidad: ${item.quantity ?? 0}',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textCardList(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      const SizedBox(height: 10.0),
                                      Text('Nota: $orderNote'),
                                      const SizedBox(height: 10.0),
                                      homeController.optionOrders == 1
                                          ? SizedBox()
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            spacing: 10.0,
                                            children: [
                                              Expanded(
                                                child: CustomDropdownButton<
                                                  String
                                                >(
                                                  color: homeController
                                                      .getDropdownColor(
                                                        homeController
                                                            .getPreparingFor(
                                                              orderId,
                                                            ),
                                                      ),
                                                  value: homeController
                                                      .getPreparingFor(orderId),
                                                  onChanged: (value) async {
                                                    final statusToSend =
                                                        homeController
                                                            .mapDropdownValueToOrderStatus(
                                                              value,
                                                            );
                                                    final String?
                                                    currentDropdownValue =
                                                        homeController
                                                            .getPreparingFor(
                                                              orderId,
                                                            );
                                                    final String
                                                    currentStatus = homeController
                                                        .mapDropdownValueToOrderStatus(
                                                          currentDropdownValue,
                                                        );
                                                    if (statusToSend ==
                                                        currentStatus) {
                                                      // ✅ Si el nuevo valor es igual al actual, no hagas nada
                                                      return;
                                                    }
                                                    homeController
                                                        .updatePreparingFor(
                                                          orderId,
                                                          value,
                                                        );
                                                    bool success =
                                                        await homeController
                                                            .postUpdateOrder(
                                                              orderId,
                                                              statusToSend,
                                                            );
                                                    if (success) {
                                                      socketService
                                                          .sendIdOrderDelivered(
                                                            orderId,
                                                            statusToSend,
                                                          );
                                                    }
                                                  },
                                                  items:
                                                      homeController
                                                          .listPreparingFor,
                                                  getLabel: (item) => item,
                                                ),
                                              ),

                                              Expanded(
                                                child: BtnSaveSec(
                                                  loading: homeController
                                                      .isOrderLoading(orderId),
                                                  text:
                                                      homeController
                                                              .isOrderLoading(
                                                                orderId,
                                                              )
                                                          ? 'Entregando'
                                                          : 'Entregar pedido',
                                                  onTap: () async {
                                                    homeController
                                                        .setOrderLoading(
                                                          orderId,
                                                          true,
                                                        );
                                                    bool success =
                                                        await homeController
                                                            .postUpdateOrder(
                                                              orderId,
                                                              'completed',
                                                            );
                                                    homeController
                                                        .setOrderLoading(
                                                          orderId,
                                                          false,
                                                        );
                                                    if (success) {
                                                      socketService
                                                          .sendIdOrderDelivered(
                                                            orderId,
                                                            'completed',
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customTextOption(String text, bool isSelected, BuildContext context) {
  return Text(
    text,
    style:
        isSelected
            ? AppTextStyle(context).bold14(
              fontWeight: FontWeight.bold,
              color: AppColors.textBasic(context),
            )
            : AppTextStyle(context).bold13(color: AppColors.textBasic(context)),
  );
}

Widget customSubTittle(String subText, String valueText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(subText, style: TextStyle(color: AppColors.black)),
      Text(valueText, style: TextStyle(color: AppColors.black)),
    ],
  );
}

Widget customSubTittleSec(String subText, String valueText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(subText, style: TextStyle(color: AppColors.black)),
      Text(
        valueText,
        style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    double zigzagHeight = 12;
    double zigzagWidth = 12;

    path.moveTo(0, 0);
    path.lineTo(0, size.height - zigzagHeight);

    // Dibujar picos en zigzag
    for (double x = 0; x < size.width; x += zigzagWidth) {
      path.lineTo(x + zigzagWidth / 2, size.height);
      path.lineTo(x + zigzagWidth, size.height - zigzagHeight);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
