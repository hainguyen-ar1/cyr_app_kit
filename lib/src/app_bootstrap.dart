import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:cyr_flutter_core/cyr_flutter_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'auth_refresh_interceptor.dart';
import 'network_inspector.dart';
import 'token_storage.dart';

class AppKitConfig {
  const AppKitConfig({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.publicAuthPaths = const [
      '/auth/login',
      '/auth/register',
      '/auth/verify-email',
      '/auth/resend-otp',
      '/auth/refresh',
      '/auth/google',
      '/auth/google/callback',
      '/auth/facebook',
      '/auth/facebook/callback',
    ],
    this.refreshPath = '/auth/refresh',
    this.enableChuckInspector = true,
    this.enableCurlLogging = false,
    this.onSessionExpired,
    this.presentation = const PresentationConfig(),
    this.setup,
  });

  /// Base URL của API.
  final String baseUrl;

  /// Headers mặc định gửi kèm mọi request.
  final Map<String, String> defaultHeaders;

  /// Các endpoint auth public không cần refresh khi 401.
  final List<String> publicAuthPaths;

  /// Đường dẫn endpoint refresh token.
  final String refreshPath;

  /// Bật Chuck network inspector (debug mode).
  final bool enableChuckInspector;

  /// Bật curl logger (debug mode).
  final bool enableCurlLogging;

  /// Được gọi khi refresh token hết hạn — dùng để chuyển về màn hình login.
  final void Function()? onSessionExpired;

  /// Cấu hình UI dùng chung (error dialog, message).
  final PresentationConfig presentation;

  /// Hook đăng ký thêm dependency vào DI locator.
  final void Function(GetIt locator)? setup;
}

late final TokenStorage _tokenStorage;

TokenStorage get appTokenStorage => _tokenStorage;

Future<void> bootstrapAppKit(AppKitConfig config) async {
  _tokenStorage = TokenStorage();
  await _tokenStorage.load();
  final chuckInterceptor = config.enableChuckInspector
      ? networkInspectorInterceptor
      : null;
  final authRefreshInterceptor = AuthRefreshInterceptor(
    tokenStorage: _tokenStorage,
    baseUrl: config.baseUrl,
    defaultHeaders: config.defaultHeaders,
    publicAuthPaths: config.publicAuthPaths,
    refreshPath: config.refreshPath,
    onSessionExpired: config.onSessionExpired,
  );

  final coreConfig = CoreConfig(
    network: NetworkConfig(
      baseUrl: config.baseUrl,
      enableLogging: false,
      defaultHeaders: config.defaultHeaders,
      headerProvider: _authHeaders,
      extraInterceptors: [
        authRefreshInterceptor,
        if (chuckInterceptor != null) chuckInterceptor,
        if (config.enableCurlLogging && kDebugMode)
          CurlLoggerDioInterceptor(printOnSuccess: true),
      ],
    ),
    presentation: config.presentation,
  );

  AppCore.initialize(
    coreConfig,
    setup: (locator) {
      registerHttpClient(coreConfig.network, locator: locator);
      authRefreshInterceptor.attach(locator<Dio>());
      registerLazySingletonOverride<TokenStorage>(
        () => _tokenStorage,
        locator: locator,
      );
      config.setup?.call(locator);
    },
  );
}

Future<Map<String, String>> _authHeaders() async {
  final token = _tokenStorage.accessToken;
  if (token == null || token.isEmpty) return {};
  return {'Authorization': 'Bearer $token'};
}
