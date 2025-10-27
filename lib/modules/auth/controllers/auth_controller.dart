import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/utils/storage_manager.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

/// Controller for handling Google Sign-In authentication
/// Manages user authentication state and navigation
class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final StorageManager _storageManager = Get.find<StorageManager>();

  final Rx<GoogleSignInAccount?> currentUser = Rx<GoogleSignInAccount?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      currentUser.value = account;
    });
  }

  /// Sign in with Google Account
  /// Shows success message and navigates to home page on success
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        currentUser.value = account;

        // Save user data to storage
        final user = UserModel(
          id: account.id,
          displayName: account.displayName ?? 'User',
          email: account.email,
          photoUrl: account.photoUrl,
        );

        await _storageManager.saveUser(user);

        Get.snackbar(
          'Success',
          'Welcome ${account.displayName}!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home page
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (error) {
      debugPrint("error = ${error.toString()}");
      // Get.snackbar(
      //   'Error',
      //   'Failed to sign in with Google',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out from Google Account
  /// Clears all storage and navigates back to login page
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      // Clear all storage
      await _storageManager.clearAll();
      currentUser.value = null;

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  bool get isSignedIn => _storageManager.isLoggedIn();
}
