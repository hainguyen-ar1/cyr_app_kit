# cyr_app_kit

Reusable Flutter app kit built on [`cyr_flutter_core`](https://pub.dev/packages/cyr_flutter_core).

The package provides bootstrap helpers for Dio networking, token refresh,
Firebase Cloud Messaging, app theming, and common widgets used across CYR
Flutter apps.

## Features

- App bootstrap around `cyr_flutter_core` network and presentation config.
- Access and refresh token storage backed by `shared_preferences`.
- Dio interceptor for automatic token refresh and request retry.
- Firebase Cloud Messaging registration, unregister, and tap handling helpers.
- Shared theme primitives, snackbar helpers, shimmer, and gradient avatar widgets.

## Getting started

Add the package to your app:

```yaml
dependencies:
  cyr_app_kit: ^0.1.0
```

Initialize the app kit before using services that depend on the shared locator:

```dart
await bootstrapAppKit(
  AppKitConfig(
    baseUrl: 'https://api.example.com',
    onSessionExpired: () {
      // Navigate the user back to sign in.
    },
  ),
);
```

## Usage

Store tokens after login:

```dart
await appTokenStorage.save(
  accessToken: accessToken,
  refreshToken: refreshToken,
);
```

Configure push notification callbacks:

```dart
final pushService = PushNotificationService(
  appTokenStorage,
  PushNotificationHandlers(
    onTokenRegister: (token, platform) async {
      // Send the FCM token to your backend.
    },
    onTokenUnregister: (token) async {
      // Remove the FCM token from your backend.
    },
    onMessageTap: (message) {
      // Route to the target screen.
    },
  ),
);

await pushService.initialize();
```

## Publishing

Run the full validation flow and publish to pub.dev:

```sh
tool/publish.sh
```

Validate without uploading:

```sh
tool/publish.sh --dry-run
```

## License

MIT
