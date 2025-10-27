import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_manager.dart';
import '../../../routes/app_routes.dart';

/// Controller for Splash Screen
/// Checks user authentication status and navigates accordingly
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    debugPrint('====== SplashController: onReady called ======');
    _checkAuthenticationAndNavigate();
  }

  /// Check if user is logged in and navigate to appropriate screen
  /// Waits 2 seconds for splash animation
  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      // Wait for splash screen animation
      await Future.delayed(const Duration(seconds: 2));

      final StorageManager storageManager = Get.find<StorageManager>();
      final isLoggedIn = storageManager.isLoggedIn();


      if (isLoggedIn) {
        final user = storageManager.getUser();

        if (user != null) {
          await Get.offAllNamed(AppRoutes.home);
        } else {
          await storageManager.clearUser();
          await Get.offAllNamed(AppRoutes.login);
        }
      } else {
        // User not logged in, navigate to login
        await Get.offAllNamed(AppRoutes.login);
      }

    } catch (e, stackTrace) {
      // On error, navigate to login as safe default
      await Get.offAllNamed(AppRoutes.login);
    }
  }
}
