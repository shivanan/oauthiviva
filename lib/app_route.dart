import 'package:flutter/material.dart';
import 'main.dart';

class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        {
          return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: ""),
          );
        }

      // case '/oauth2redirect':
      //   return MaterialPageRoute(
      //     builder: (_) => const OAuthScreen(
      //       details: args,
      //     ),
      //   );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(_);
              }),
          backgroundColor: Colors.white,
          title: const Text(''),
        ),
        body: Center(
          child: Image.asset('assets/404_not_found.png'),
        ),
      );
    });
  }
}
