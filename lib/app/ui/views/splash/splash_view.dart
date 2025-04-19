import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/views/login/login_controller.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simula una espera antes de redirigir a la vista de inicio de sesión
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => LoginController(),
            child: const LoginView(),
          ),
        ),
      );
    });
    
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(

              ),
        ),
      ),
    );
  }
}
