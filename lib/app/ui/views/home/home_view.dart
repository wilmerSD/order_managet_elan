import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:order_manager/app/ui/components/alert/alert_dialog_component.dart';
import 'package:order_manager/app/ui/components/button/btn_save_sec.dart';
import 'package:order_manager/app/ui/views/home/home_controller.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
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
      homeController.getOrderProcessingv1(context, 'processing');
      socketService.socket.on('nuevo_pedido', (data) {
        homeController.listenNewOrder(data);
      });

      socketService.socket.on('order_delivered_emit', (orderId) {
        print(orderId);
        try {
          final int id = int.parse(orderId.toString());
          homeController.removeOrderFromList(id);
          homeController.getOrderProcessing('processing');
        } catch (e) {
          print('❌ Error al convertir orderId: $orderId');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final prefs = PreferencesUser();

    Widget darkMode = IconButton(
      onPressed: () {
        bool value = prefs.themeBool;
        prefs.themeBool = !value;
        Provider.of<ThemeProvider>(context, listen: false).getValueTheme =
            !value;
      },
      icon: Icon(prefs.themeBool ? Icons.dark_mode_outlined : Icons.light_mode),
      color: Colors.white,
    );

    Widget logo = Container(
      width: 50.0,
      height: 50.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/elan_logo.png'), // Reemplaza con tu imagen
          fit: BoxFit.scaleDown,
        ),
      ),
    );
    final width = MediaQuery.of(context).size.width;
    int getCrossAxisCount(double width, double itemWidth) {
      return (width / itemWidth).floor();
    }

    final crossAxisCount = getCrossAxisCount(width, 300);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.primaryConst,
        title: logo,
        actions: [
          Consumer<HomeController>(
            builder: (context, timeProvider, child) {
              return Text(
                timeProvider.currentTime,
                style: AppTextStyle(context).bold15(),
              );
            },
          ),
          SizedBox(width: 20.0),
          Text(
            context.read<HomeController>().fullName,
            style: AppTextStyle(context).bold15(),
          ),
          SizedBox(width: 20.0),
          darkMode,
          SizedBox(width: 20.0),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogComponent(
                    onTapButton: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    title: "¿Seguro que quieres salir de tasking?",
                  );
                },
              );
            },
            child: Text('Cerrar sesión', style: AppTextStyle(context).bold15()),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 20.0,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<HomeController>().getOrderProcessingv1(
                          context,
                          'processing',
                        );
                        homeController.optionOrders = 0;
                      },
                      child: customTextOption(
                        'En proceso',
                        homeController.optionOrders == 0,
                        context,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<HomeController>().getOrderCompleted(
                          context,
                          'completed',
                        );
                        homeController.optionOrders = 1;
                      },
                      child: customTextOption(
                        'Completos',
                        homeController.optionOrders == 1,
                        context,
                      ),
                    ),
                  ],
                ),
                Text('Pedidos en cola: ${homeController.orderTotalProcessing}'),
              ],
            ),
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
                      : MasonryGridView.count(
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
                          final customerLastName =
                              order.billing?.lastName ?? '';
                          final items = order.lineItems ?? [];

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSubTittle(
                                      'N° de pedido:',
                                      '${order.id}',
                                    ),
                                    customSubTittle(
                                      'Cliente:',
                                      '$customerName $customerLastName',
                                    ),
                                    customSubTittle(
                                      'Hora:',
                                      Helpers.formatTime(order.dateCreated),
                                    ),
                                    Text(
                                      'Productos',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textCardList(context),
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
                                                    BorderRadius.circular(6.0),
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
                                                          Colors.grey.shade300,
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
                                    homeController.optionOrders == 1
                                        ? SizedBox()
                                        : BtnSaveSec(
                                          loading: homeController
                                              .isOrderLoading(orderId),
                                          text: 'Entregar pedido',
                                          onTap: () async {
                                            homeController.setOrderLoading(
                                              orderId,
                                              true,
                                            );
                                            bool success = await homeController
                                                .postUpdateOrder(orderId);
                                            homeController.setOrderLoading(
                                              orderId,
                                              false,
                                            );
                                            if (success) {
                                              socketService
                                                  .sendIdOrderDelivered(
                                                    orderId,
                                                  );
                                            }
                                          },
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
