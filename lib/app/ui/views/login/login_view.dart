import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/button/btn_primary_ink.dart';
import 'package:order_manager/app/ui/components/field_form.dart';
import 'package:order_manager/app/ui/views/login/login_controller.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ya que se está utilizando Provider, no necesitas definirlo de nuevo aquí.
    final logincontroller = Provider.of<LoginController>(context);

    Widget password = FieldForm(
      label: "Contraseña",
      hintText: "Ingresa tu contraseña",
      privateText: true,
      suffix: GestureDetector(
        onTap: () {
          //logincontroller.toggleVisibility(); // Método para cambiar la visibilidad
        },
        child: Icon(
          logincontroller.isVisibleIcon
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
      textEditingController: logincontroller.ctrlPasswordText,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        // Lógica para validar el formulario
      },
    );
    Widget user = FieldForm(
      label: "Usuario",
      hintText: "Ingresa tu usuario",
      textInputType: TextInputType.emailAddress,
      textEditingController: logincontroller.ctrlEmailText,
    );
    Widget button = BtnPrimaryInk(
      text: "Ingresar",

      onTap: () => logincontroller.login(context),
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Container(
            width: 350.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 244, 244, 244),
              borderRadius: BorderRadius.circular(8.0),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Text(
                  'Elan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryConst,
                  ),
                ),
                SizedBox(height: 25.0),
                // Usuario
                user,
                SizedBox(height: 25.0),
                // Contraseña
                password,
                SizedBox(height: 25.0),
                //Boton
                button,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
