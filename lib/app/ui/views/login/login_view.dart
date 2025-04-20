import 'package:flutter/material.dart';
import 'package:order_manager/app/ui/components/button/btn_primary_ink.dart';
import 'package:order_manager/app/ui/components/field_form.dart';
import 'package:order_manager/app/ui/views/login/login_controller.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState(){
    
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final loginController = Provider.of<LoginController>(
        context,
        listen: false,
      );
      await loginController.getCredentials();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ya que se está utilizando Provider, no necesitas definirlo de nuevo aquí.
    final logincontroller = Provider.of<LoginController>(context);

    Widget password = FieldForm(
      label: "Contraseña",
      hintText: "Ingresa tu contraseña",
      privateText: logincontroller.visiblePassword,
      suffix: IconButton(
        onPressed: () => logincontroller.visiblePassword = !logincontroller.visiblePassword,
        icon: Icon(
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
      loading: logincontroller.isValidating,
      onTap: () => logincontroller.login(context),
    );

    Widget rememberPass = InkWell(
      onTap: () {
        logincontroller.rememberPass = !logincontroller.rememberPass;
      },
      child: Row(
        children: [
          Checkbox(
            activeColor: AppColors.primary(context),
            value: logincontroller.rememberPass,
            onChanged: (_) {
              logincontroller.rememberPass = !logincontroller.rememberPass;
            },
          ),
          const Text("Recordar datos"),
        ],
      ),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Container(
            width: 350.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor(context),
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
                rememberPass,
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
