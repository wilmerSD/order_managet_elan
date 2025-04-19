import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/alert/alert_dialog_component.dart';
import 'package:order_manager/app/ui/components/button/btn_save_sec.dart';
import 'package:order_manager/app/ui/views/home/home_controller.dart';
import 'package:order_manager/app/ui/views/login/login_controller.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeController = Provider.of<HomeController>(
        context,
        listen: false,
      );
      homeController.timeProvider();
      homeController.obtenerPedidosPendientes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.primaryConst,
        title: Text('Elan', style: AppTextStyle(context).bold18()),
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
            Row(spacing: 20.0, children: [Text('Pedidos'), Text('Completos')]),
            /* IconButton(
              onPressed: () {
                context.read<HomeController>().obtenerPedidosPendientes();
              },
              icon: Icon(Icons.get_app),
            ), */
            homeController.isGettingListOrders
                ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryConst,
                  ),
                )
                : Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        homeController.listOrders.map((order) {
                          debugPrint("hola1");
                          final customerName =
                              order.billing?.firstName ?? 'Sin nombre';
                          final customerLastName =
                              order.billing?.lastName ?? '';
                          final items = order.lineItems ?? [];
                          print(items.length);
                          debugPrint(items.toString());
                          debugPrint("hola2");
                          return SizedBox(
                            width: 200,
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cliente: $customerName $customerLastName',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    /* Column(
                                      children: items.map((item) {
                                        return Text(item['name']);
                                      }).toList(),
                                    ), */
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
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  item.image!.src!,
                                                  height: 40,
                                                  width: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      height: 40,
                                                      width: 40,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            else
                                              const SizedBox(
                                                width: 40,
                                                height: 40,
                                              ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name ?? 'Sin nombre',
                                                  ),
                                                  Text(
                                                    'Cantidad: ${item.quantity ?? 0}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    SizedBox(height: 10.0),
                                    BtnSaveSec(
                                      text: 'Entregar pedido',
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
