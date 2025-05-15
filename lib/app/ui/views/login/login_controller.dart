import "package:flutter/material.dart";
import "package:order_manager/app/ui/views/home/home_controller.dart";
import "package:order_manager/app/ui/views/home/home_view.dart";
import "package:order_manager/core/helpers/custom_snackbar.dart";
import "package:order_manager/core/helpers/keys.dart";
import "package:order_manager/core/theme/app_colors.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class LoginController with ChangeNotifier {
  int counter = 0;
  TextEditingController ctrlEmailText = TextEditingController(text: '');
  TextEditingController ctrlPasswordText = TextEditingController(text: '');

  bool isVisibleIcon = false;
  bool _isValidating = false;
  bool _rememberPass = false;
  bool _visiblePassword = true;

  set rememberPass(bool value) {
    _rememberPass = value;
    notifyListeners();
  }

  set isValidating(bool value) {
    _isValidating = value;
    notifyListeners();
  }

  set visiblePassword(bool value) {
    _visiblePassword = value;
    notifyListeners();
  }

  bool get isValidating => _isValidating;
  bool get rememberPass => _rememberPass;
  bool get visiblePassword => _visiblePassword;

  String eUser = 'wilmer';
  String ePassword = 'wilmer1';

  String eUser2 = 'wilmer2';
  String ePassword2 = 'wilmer2';

  String nameUser = '';
  String lastName = '';

  void login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    isValidating = true;

    final email = ctrlEmailText.text.trim();
    final password = ctrlPasswordText.text;

    // Validaciones iniciales
    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar.showSnackBarCustom(
        context,
        title: 'Validar',
        message:
            email.isEmpty ? 'Ingresar su usuario' : 'Ingresar su contraseña',
        color: AppColors.warningColor,
      );
      isValidating = false;
      return;
    }

    // Lista de usuarios válidos
    final users = [
      {
        'email': eUser.toUpperCase() ,
        'password': ePassword,
        'name': 'Jose Wilmer',
        'lastName': 'Sánchez Díaz',
      },
      {
        'email': eUser2.toUpperCase() ,
        'password': ePassword2,
        'name': 'Luis',
        'lastName': 'Torres',
      },
    ];

    // Buscar usuario válido
    final user = users.firstWhere(
      (u) => u['email'] == email.toUpperCase()  && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      nameUser = user['name']!;
      lastName = user['lastName']!;
      context.read<HomeController>().fullName = '$nameUser $lastName';

      // Guardar o limpiar credenciales
      if (rememberPass) {
        prefs.setString(Keys.kUserName, email);
        prefs.setString(Keys.kPassword, password);
        prefs.setBool(Keys.kRemenberPass, true);
      } else {
        prefs.remove(Keys.kUserName);
        prefs.remove(Keys.kPassword);
        prefs.setBool(Keys.kRemenberPass, false);
      }

      ctrlEmailText.clear();
      ctrlPasswordText.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else {
      CustomSnackbar.showSnackBarCustom(
        context,
        title: 'Validar',
        message: 'Usuario o contraseña incorrecta',
        color: AppColors.warningColor,
      );
    }
    isValidating = false;
  }

  Future<void> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ctrlEmailText.text = prefs.getString(Keys.kUserName) ?? '';
    ctrlPasswordText.text = prefs.getString(Keys.kPassword) ?? '';
    rememberPass = prefs.getBool(Keys.kRemenberPass) ?? false;
    notifyListeners();
  }
}
