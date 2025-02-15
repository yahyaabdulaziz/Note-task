import 'package:flutter/material.dart';
import 'package:notes/helpers/strings_manager.dart';
import 'package:notes/presentation/screens/home_screen_view/home_screen.dart';
import 'package:notes/presentation/screens/login_screen_view/login_screen.dart';
import 'package:notes/presentation/screens/splash_screen_view/splash_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginScreenRoute = "/loginScreenRoute";
  static const String homeScreenRoute = "/homeScreenRoute";
}

class RouteGenerator {
  static get args => null;

  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginScreenRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound.trim()),
              ),
              body: Center(child: Text(AppStrings.noRouteFound.trim())),
            ));
  }
}
