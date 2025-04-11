import 'package:casha/constants/routes.dart';
import 'package:casha/ui/simple_calc_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Navigation {
  static Route<RouteSettings> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME_SCREEN:
        return _routeEndPoint(SimpleCalcView(), settings);
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<RouteSettings> _routeEndPoint(Widget builder, RouteSettings settings, {bool fullScreenDialog = false}) {
    return CupertinoPageRoute(
      settings: settings,
      fullscreenDialog: fullScreenDialog,
      builder: (_) => builder,
    );
  }

  static Route<RouteSettings> _errorRoute(route) {
    return CupertinoPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Error'),
          ),
          body: Center(
            child: Text("This path doesn't exist, please check the 'Navigation' class for available routes. The route is: $route"),
          ),
        );
      },
    );
  }
}
