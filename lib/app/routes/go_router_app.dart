import 'package:go_router/go_router.dart';
import 'package:order_manager/app/routes/app_routes_name.dart';
import 'package:order_manager/app/ui/views/home/home_view.dart';
import 'package:order_manager/app/ui/views/login/login_view.dart';
import 'package:order_manager/app/ui/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

/// 🌍 Configuración de go_router
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // AppRoutesName.SPLASH, // tu pantalla inicial
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashView()),
    GoRoute(
      path: AppRoutesName.LOGIN,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppRoutesName.HOME,
      builder: (context, state) => const HomeView(),
    ),
  ],
  // redirect: (context, state) {
  //   final auth = Provider.of<AuthProvider>(context, listen: false);
  //   // 🔹 Mientras carga, no redirijas nada
  //   if (auth.isLoading) return null;

  //   final loggedIn = auth.isLoggedIn;
  //   final loggingIn = state.uri.path == AppRoutesName.LOGIN; //'/login';

  //   // Si no está logueado y no está en /login -> redirigir a login
  //   if (!loggedIn && !loggingIn) return AppRoutesName.LOGIN; //'/login';

  //   // Si ya está logueado y está en /login -> mandarlo a home
  //   if (loggedIn && loggingIn) return AppRoutesName.HOME; //'/home';

  //   // Dejar pasar
  //   return null;
  // },
);
