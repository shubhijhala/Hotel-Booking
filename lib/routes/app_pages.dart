import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/home_page.dart';
import '../modules/hotel_details/controllers/hotel_details_controller.dart';
import '../modules/hotel_details/views/hotel_details_page.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.hotelDetails,
      page: () => const HotelDetailsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HotelDetailsController>(() => HotelDetailsController());
      }),
    ),
  ];
}
