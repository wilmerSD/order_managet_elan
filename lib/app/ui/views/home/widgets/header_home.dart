import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/custom_dropdown_transparent.dart';
import 'package:order_manager/app/ui/views/home/home_provider.dart';
import 'package:order_manager/app/ui/views/home/home_view.dart';
import 'package:provider/provider.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          spacing: 20.0,
          children: [
            InkWell(
              onTap: () {
                context.read<HomeController>().getOrderProcessingv1(
                  context,
                  'processing,prepamarillo,prepverde,prepazul,preprojo',
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
                context.read<HomeController>().getOrderCompleted(context);
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
        SizedBox(
          width: 200,
          child: CustomDropdownTransparent(
            value: homeController.nroOrder,
            items: homeController.listNroOrders,
            onChanged: (value) {
              homeController.filterNroOrder(value);
            },
            label: 'Nro pedido',
            getLabel: (item) => item,
          ),
        ),
      ],
    );
  }
}
