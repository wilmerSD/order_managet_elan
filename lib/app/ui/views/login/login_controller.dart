import "package:flutter/material.dart";
import "package:order_manager/app/ui/views/home/home_controller.dart";
import "package:order_manager/app/ui/views/home/home_view.dart";
import "package:provider/provider.dart";

class LoginController with ChangeNotifier {
  
  int counter = 0;
  TextEditingController ctrlEmailText = TextEditingController(text: 'wilmer');
  TextEditingController ctrlPasswordText = TextEditingController(
    text: 'wilmer1',
  );
  
  
  bool isVisibleIcon = false;

  String eUser = 'wilmer';
  String ePassword = 'wilmer1';

  String eUser2 = 'wilmer2';
  String ePassword2 = 'wilmer2';

  String nameUser = '';
  String lastName = '';

  void login(BuildContext context) {
    if (ctrlEmailText.text.isEmpty) {}
    if (ctrlPasswordText.text.isEmpty) {}
    if (ctrlEmailText.text == eUser && ctrlPasswordText.text == ePassword) {
      nameUser = 'Jose Wilmer';
      lastName = 'Sánchez Díaz';
      context.read<HomeController>().fullName = '$nameUser $lastName';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
    if (ctrlEmailText.text == eUser2 && ctrlPasswordText.text == ePassword2) {
      nameUser = 'Luis';
      lastName = 'Torres';
      context.read<HomeController>().fullName = '$nameUser $lastName';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }
}
