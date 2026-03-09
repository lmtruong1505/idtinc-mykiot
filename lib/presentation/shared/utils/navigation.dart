import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

extension AppNav on BuildContext {
  Future<T?> navPush<T extends Object?>(
    PageRouteInfo<dynamic> route, {
    void Function(NavigationFailure)? onFailure,
  }) async {
    return router.push<T>(route, onFailure: onFailure);
  }
}
