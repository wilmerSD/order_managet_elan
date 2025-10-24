import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/alert/alert_dialog_component.dart';
import 'package:order_manager/app/ui/views/home/home_provider.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
import 'package:order_manager/core/preferences/shared_preferences.dart';
import 'package:order_manager/core/preferences/theme_provider.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColors.primaryConst,
      title: Consumer<HomeController>(
        builder: (context, provider, child) {
          return Row(
            children: [
              logo,
              SizedBox(width: 10.0),
              _textButton(context, 'all', 'Todos'),
              _textButton(context, 'no_menu', 'Cafetería'),
              _textButton(context, 'menu', 'Comedor'),
              // _textButton(context,'all', () {
              //   provider.getJustRestaurant(filterType: 'all');
              //   provider.setSelectedFilter('all');
              // }, 'Todos'),
              // _textButton('no_menu', () {
              //   provider.getJustRestaurant(filterType: 'no_menu');
              //   provider.setSelectedFilter('no_menu');
              // }, 'Cafeteria'),
              // _textButton('menu', () {
              //   provider.getJustRestaurant(filterType: 'menu');
              //   provider.setSelectedFilter('menu');
              // }, 'Comedor'),
            ],
          );
        },
      ),
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
    );
  }
}

// Widget _textButton(String filterType, VoidCallback onPressed, String text) {
//   return TextButton(
//     onPressed: onPressed,
//     child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15.0)),
//   );
// }

Widget _textButton(BuildContext context, String filterType, String text) {
  final provider = Provider.of<HomeController>(context);
  final isSelected = provider.selectedFilter == filterType;

  return TextButton(
    onPressed: () => provider.setSelectedFilter(filterType),
    style: TextButton.styleFrom(
      backgroundColor: isSelected ? Colors.white24 : Colors.transparent,
      side: BorderSide(
        color: isSelected ? Colors.white : Colors.transparent,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
