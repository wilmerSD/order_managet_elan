import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/alert/alert_dialog_component.dart';
import 'package:order_manager/app/ui/components/button/btn_save_sec.dart';
import 'package:order_manager/app/ui/views/home/home_controller.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
import 'package:order_manager/core/preferences/shared_preferences.dart';
import 'package:order_manager/core/preferences/theme_provider.dart';
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
      homeController.getOrderProcessing(context, 'processing');
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
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
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
              spacing: 20.0,
              children: [
                InkWell(
                  onTap: () {
                    context.read<HomeController>().getOrderProcessing(
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
                    context.read<HomeController>().getOrderProcessing(
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
                      : Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children:
                            homeController.listOrders.map((order) {
                              final orderId = order.id ?? 0;
                              final customerName =
                                  order.billing?.firstName ?? 'Sin nombre';
                              final customerLastName =
                                  order.billing?.lastName ?? '';
                              final items = order.lineItems ?? [];
                              return SizedBox(
                                width: 200.0,
                                child: Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cliente: $customerName $customerLastName',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.name ??
                                                            'Sin nombre',
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
                                        }),
                                        SizedBox(height: 10.0),
                                        homeController.optionOrders == 1
                                            ? SizedBox()
                                            : BtnSaveSec(
                                              loading:
                                                  homeController
                                                      .isUpdatingOrder,
                                              text: 'Entregar pedido',
                                              onTap: () {
                                                homeController.postUpdateOrder(
                                                  orderId,
                                                );
                                              },
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
