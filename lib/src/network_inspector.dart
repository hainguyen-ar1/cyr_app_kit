import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

final Chuck? _networkInspector = kDebugMode
    ? Chuck(
        navigatorKey: appNavigatorKey,
        showNotification: true,
        showInspectorOnShake: true,
        maxCallsCount: 200,
      )
    : null;

Interceptor? get networkInspectorInterceptor =>
    _networkInspector?.dioInterceptor;

void showNetworkInspector() => _networkInspector?.showInspector();