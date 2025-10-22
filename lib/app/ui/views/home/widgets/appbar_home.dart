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

  const CustomAppBar({
    super.key,
  });

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
      );
  }
}
