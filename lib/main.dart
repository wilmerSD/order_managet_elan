import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/views/home/home_controller.dart';
import 'package:order_manager/app/ui/views/login/login_controller.dart';
import 'package:order_manager/app/ui/views/splash/splash_view.dart';
import 'package:order_manager/core/preferences/shared_preferences.dart';
import 'package:order_manager/core/preferences/theme_provider.dart';
import 'package:order_manager/core/service/sokect_service.dart';
import 'package:order_manager/core/theme/theme_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesUser.init();
  // final socketService = SocketService();
  // socketService.initSocket();
  // await initializeDateFormatting("ES", '');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider<HomeController>(create: (_) => HomeController()),
        ChangeNotifierProvider(
        create: (_) => ThemeProvider(darkMode: PreferencesUser().themeBool)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elan',
      theme: ThemeApp(
                darkMode:
                    Provider.of<ThemeProvider>(context, listen: true).themeDark)
            .getTheme(),
      home: const SplashView(),
    );
  }
}
