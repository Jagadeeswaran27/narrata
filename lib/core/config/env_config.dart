import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get androidApiKey => dotenv.env['ANDROID_API_KEY'] ?? '';
  static String get androidAppId => dotenv.env['ANDROID_APP_ID'] ?? '';
  static String get iosApiKey => dotenv.env['IOS_API_KEY'] ?? '';
  static String get iosAppId => dotenv.env['IOS_APP_ID'] ?? '';
  static String get messagingSenderId =>
      dotenv.env['MESSAGING_SENDER_ID'] ?? '';
  static String get projectId => dotenv.env['PROJECT_ID'] ?? '';
  static String get storageBucket => dotenv.env['STORAGE_BUCKET'] ?? '';
  static String get iosBundleId => dotenv.env['IOS_BUNDLE_ID'] ?? '';
}
