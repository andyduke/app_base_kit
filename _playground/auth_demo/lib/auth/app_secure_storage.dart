import 'package:app_base_kit/app_base_kit.dart';
import 'package:simple_secure_storage/simple_secure_storage.dart';

class AppSecureStorage extends SecureStorage {
  /// Creates or returns an instance of the secure
  /// storage (there is always only one instance)
  factory AppSecureStorage() {
    return _instance ??= AppSecureStorage._();
  }

  AppSecureStorage._() : super();

  static AppSecureStorage? _instance;

  @override
  Future<void> initialize() async {
    await SimpleSecureStorage.initialize(
      const InitializationOptions(
        appName: 'com.amazingsoftworks.app_base_kit_example',
        namespace: 'AmazingSoftworksAppBaseKitExampleSecureStorage',
      ),
    );
  }

  @override
  Future<bool> has(String key) async {
    return SimpleSecureStorage.has(key);
  }

  @override
  Future<String?> read(String key) async {
    return SimpleSecureStorage.read(key);
  }

  @override
  Future<void> write(String key, String value) async {
    return SimpleSecureStorage.write(key, value);
  }

  @override
  Future<void> delete(String key) async {
    return SimpleSecureStorage.delete(key);
  }

  @override
  Future<void> clear() async {
    return SimpleSecureStorage.clear();
  }
}
