import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'token_storage.dart';

/// Callbacks mà host app cung cấp để xử lý logic riêng của từng app
/// (token sync lên server, điều hướng khi tap notification).
class PushNotificationHandlers {
  const PushNotificationHandlers({
    required this.onTokenRegister,
    required this.onTokenUnregister,
    this.onMessageTap,
  });

  /// Đăng ký FCM token lên server của app.
  final Future<void> Function(String token, String platform) onTokenRegister;

  /// Hủy đăng ký FCM token khi logout.
  final Future<void> Function(String token) onTokenUnregister;

  /// Xử lý khi người dùng tap notification (điều hướng màn hình).
  final void Function(RemoteMessage message)? onMessageTap;
}

/// Quản lý Firebase Cloud Messaging push notification.
class PushNotificationService {
  PushNotificationService(this._tokenStorage, this.handlers);

  final TokenStorage _tokenStorage;
  final PushNotificationHandlers handlers;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await syncToken();

    _tokenRefreshSub = _messaging.onTokenRefresh.listen((token) {
      debugPrint('---FCM token refreshed: $token');
      unawaited(_registerToken(token));
    });

    final onTap = handlers.onMessageTap;
    if (onTap != null) {
      _openedSub = FirebaseMessaging.onMessageOpenedApp.listen(onTap);
    }

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onTap?.call(initialMessage);
    }
  }

  Future<void> syncToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('---FCM token: ${token ?? '(null)'}');
      if (token == null || token.isEmpty || !_tokenStorage.hasToken) return;
      await _registerToken(token);
    } catch (err) {
      log('Unable to sync FCM token: $err', name: 'PushNotification');
    }
  }

  Future<void> unregisterCurrentToken() async {
    if (!_tokenStorage.hasToken) return;

    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;
      await handlers.onTokenUnregister(token);
    } catch (err) {
      log('Unable to unregister FCM token: $err', name: 'PushNotification');
    }
  }

  Future<void> _requestPermission() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (err) {
      log(
        'Notification permission request failed: $err',
        name: 'PushNotification',
      );
    }
  }

  Future<void> _registerToken(String token) async {
    if (!_tokenStorage.hasToken) return;

    try {
      await handlers.onTokenRegister(token, _platformName());
    } catch (err) {
      log('Unable to register FCM token: $err', name: 'PushNotification');
    }
  }

  String _platformName() {
    if (kIsWeb) return 'web';

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'unknown',
    };
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _openedSub?.cancel();
  }
}