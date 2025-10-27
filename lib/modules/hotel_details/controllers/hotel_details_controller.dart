import 'package:get/get.dart';
import '../../../data/models/hotel_model.dart';

/// Controller for Hotel Details Page
/// Displays detailed information about a selected hotel
class HotelDetailsController extends GetxController {
  late final Rx<HotelModel> hotel;

  @override
  void onInit() {
    super.onInit();

    // Get hotel data from arguments
    if (Get.arguments != null && Get.arguments is HotelModel) {
      hotel = (Get.arguments as HotelModel).obs;
    } else {
      // If no hotel provided, go back
      Get.back();
    }
  }
}
