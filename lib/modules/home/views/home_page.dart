import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/storage_manager.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/filter_dialog.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageManager storageManager = Get.find<StorageManager>();
    final user = storageManager.getUser();

    return PopScope(
      canPop: false, // Prevent back button from popping the route
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          // Show exit confirmation dialog
          Get.dialog(
            AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    // Exit app
                    Get.find<AuthController>().signOut();
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hotel Booking',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              if (user != null)
                Text(
                  'Welcome, ${user.displayName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
          actions: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: user.photoUrl != null
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
              ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.find<AuthController>().signOut();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredHotels.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hotel_outlined,
                        size: 80,
                        color: AppColors.grey,
                      ),
                      16.verticalSpace,
                      const Text(
                        'No hotels found',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      16.verticalSpace,
                      ElevatedButton.icon(
                        onPressed: controller.loadInitialHotels,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredHotels.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.filteredHotels.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final hotel = controller.filteredHotels[index];
                    return _buildHotelCard(hotel);
                  },
                ),
              );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => TextField(
              controller: controller.searchTextController,
              onChanged: (value) {
                controller.searchQuery.value = value;
                // Auto-search: Show results on home page as user types
                controller.performAutoSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by hotel name, city, or state...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel, color: AppColors.grey),
                        onPressed: controller.clearSearch,
                        tooltip: 'Clear search',
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            )),
          ),
          12.horizontalSpace,
          // Filter button
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                Get.dialog(const FilterDialog());
              },
              tooltip: 'Advanced Filters',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(hotel) {
    return InkWell(
      onTap: () {
        // Navigate to hotel details page
        Get.toNamed(AppRoutes.hotelDetails, arguments: hotel);
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Hotel Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: hotel.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: hotel.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.hotel,
                        size: 60,
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.hotel,
                      size: 60,
                      color: AppColors.grey,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Name
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                8.verticalSpace,

                // Location
                if (hotel.city != null || hotel.state != null || hotel.country != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.grey),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          [hotel.city, hotel.state, hotel.country]
                              .where((e) => e != null)
                              .join(', '),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                8.verticalSpace,

                // Rating and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hotel.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          4.horizontalSpace,
                          Text(
                            hotel.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    if (hotel.price != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${hotel.price!.toStringAsFixed(0)}/night',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
