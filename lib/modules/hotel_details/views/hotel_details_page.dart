import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/hotel_model.dart';
import '../controllers/hotel_details_controller.dart';

class HotelDetailsPage extends GetView<HotelDetailsController> {
  const HotelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final hotel = controller.hotel.value;

        return CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primary),
                ),
                onPressed: () => Get.back(),
              ),
              actions: [
                if (hotel.isFavorite != null)
                  IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hotel.isFavorite! ? Icons.favorite : Icons.favorite_border,
                        color: hotel.isFavorite! ? Colors.red : AppColors.primary,
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        'Favorites',
                        'Favorites feature coming soon!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hotel Image
                    hotel.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: hotel.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.hotel,
                                size: 80,
                                color: AppColors.grey,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.hotel,
                              size: 80,
                              color: AppColors.grey,
                            ),
                          ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hotel Details Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating Card
                  Container(
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          hotel.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        12.verticalSpace,
                        // Property Type and Stars
                        Row(
                          children: [
                            if (hotel.propertyType != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  hotel.propertyType!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              12.horizontalSpace,
                            ],
                            if (hotel.stars != null)
                              Row(
                                children: List.generate(
                                  hotel.stars!.clamp(0, 5),
                                  (index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        16.verticalSpace,
                        // Rating
                        if (hotel.rating != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                                8.horizontalSpace,
                                Text(
                                  hotel.rating!.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (hotel.totalReviews != null) ...[
                                  8.horizontalSpace,
                                  Text(
                                    '(${hotel.totalReviews} reviews)',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        // Property Views
                        if (hotel.propertyView != null) ...[
                          12.verticalSpace,
                          Row(
                            children: [
                              Icon(Icons.visibility, size: 16.w, color: AppColors.grey),
                              4.horizontalSpace,
                              Text(
                                '${hotel.propertyView} views',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Room Information
                  if (hotel.roomName != null || hotel.numberOfAdults != null)
                    _buildSection(
                      icon: Icons.meeting_room,
                      title: 'Room Information',
                      child: Column(
                        children: [
                          if (hotel.roomName != null)
                            _buildInfoRow('Room Type', hotel.roomName!),
                          if (hotel.numberOfAdults != null)
                            _buildInfoRow('Adults', '${hotel.numberOfAdults}'),
                        ],
                      ),
                    ),

                  // Amenities Section
                  _buildSection(
                    icon: Icons.check_circle_outline,
                    title: 'Amenities & Features',
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (hotel.freeWifi == true)
                          _buildAmenityChip('Free WiFi', Icons.wifi),
                        if (hotel.freeCancellation == true)
                          _buildAmenityChip('Free Cancellation', Icons.cancel),
                        if (hotel.coupleFriendly == true)
                          _buildAmenityChip('Couple Friendly', Icons.favorite),
                        if (hotel.suitableForChildren == true)
                          _buildAmenityChip('Kids Friendly', Icons.child_care),
                        if (hotel.petsAllowed == true)
                          _buildAmenityChip('Pets Allowed', Icons.pets),
                        if (hotel.bachularsAllowed == true)
                          _buildAmenityChip('Bachelors Welcome', Icons.people),
                        if (hotel.payNow == true)
                          _buildAmenityChip('Pay Now', Icons.payment),
                        if (hotel.payAtHotel == true)
                          _buildAmenityChip('Pay at Hotel', Icons.hotel),
                      ],
                    ),
                  ),

                  // Location Section
                  if (hotel.city != null || hotel.state != null || hotel.country != null)
                    _buildSection(
                      icon: Icons.location_on,
                      title: 'Location',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hotel.address != null) ...[
                            Text(
                              hotel.address!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                            12.verticalSpace,
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                size: 18.w,
                                color: AppColors.primary,
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  [hotel.city, hotel.state, hotel.country]
                                      .where((e) => e != null)
                                      .join(', '),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (hotel.zipcode != null) ...[
                            8.verticalSpace,
                            Row(
                              children: [
                                Icon(
                                  Icons.markunread_mailbox,
                                  size: 18.w,
                                  color: AppColors.primary,
                                ),
                                8.horizontalSpace,
                                Text(
                                  'Zipcode: ${hotel.zipcode}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                  // Pricing Section
                  _buildSection(
                    icon: Icons.payments,
                    title: 'Pricing',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hotel.propertyMinPrice != null && hotel.propertyMaxPrice != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price Range',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    '${hotel.currencySymbol ?? ''} ${hotel.propertyMinPrice!.toStringAsFixed(0)} - ${hotel.propertyMaxPrice!.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          16.verticalSpace,
                        ],
                        if (hotel.price != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${hotel.currencySymbol ?? '\$'}${hotel.price!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              4.horizontalSpace,
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Text(
                                  '/ night',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (hotel.markedPrice != null &&
                            hotel.price != null &&
                            hotel.markedPrice! > hotel.price!) ...[
                          8.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '${hotel.currencySymbol ?? '\$'}${hotel.markedPrice!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              12.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '${(((hotel.markedPrice! - hotel.price!) / hotel.markedPrice!) * 100).toStringAsFixed(0)}% OFF',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Policies Section
                  if (hotel.cancelPolicy != null || hotel.refundPolicy != null)
                    _buildSection(
                      icon: Icons.policy,
                      title: 'Policies',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hotel.cancelPolicy != null)
                            _buildPolicyItem('Cancellation Policy', hotel.cancelPolicy!, Icons.cancel_outlined),
                          if (hotel.refundPolicy != null)
                            _buildPolicyItem('Refund Policy', hotel.refundPolicy!, Icons.money_off),
                          if (hotel.childPolicy != null)
                            _buildPolicyItem('Child Policy', hotel.childPolicy!, Icons.child_care),
                          if (hotel.damagePolicy != null)
                            _buildPolicyItem('Damage Policy', hotel.damagePolicy!, Icons.warning_amber),
                          if (hotel.propertyRestriction != null)
                            _buildPolicyItem('Restrictions', hotel.propertyRestriction!, Icons.info_outline),
                        ],
                      ),
                    ),

                  // Available Deals
                  if (hotel.availableDeals != null && hotel.availableDeals!.isNotEmpty)
                    _buildSection(
                      icon: Icons.local_offer,
                      title: 'Available Deals',
                      child: Column(
                        children: hotel.availableDeals!.map((deal) => _buildDealCard(deal)).toList(),
                      ),
                    ),

                  // Additional Info Section
                  _buildSection(
                    icon: Icons.info_outline,
                    title: 'Additional Information',
                    child: Column(
                      children: [
                        _buildInfoRow('Property Code', hotel.id),
                        if (hotel.latitude != null && hotel.longitude != null)
                          _buildInfoRow(
                            'Coordinates',
                            '${hotel.latitude!.toStringAsFixed(4)}, ${hotel.longitude!.toStringAsFixed(4)}',
                          ),
                      ],
                    ),
                  ),

                  // Book Now Button
                  Container(
                    margin: EdgeInsets.all(16.w),
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (hotel.propertyUrl != null) {
                          _launchUrl(hotel.propertyUrl!);
                        } else {
                          Get.snackbar(
                            'Booking',
                            'Booking functionality will be available soon!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: AppColors.textPrimary,
                            margin: EdgeInsets.all(16.w),
                            borderRadius: 12.r,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  32.verticalSpace,
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              12.horizontalSpace,
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: Colors.green.shade700),
          6.horizontalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String title, String description, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.w, color: AppColors.primary),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                4.verticalSpace,
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(HotelDeal deal) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (deal.headerName != null)
                  Text(
                    deal.headerName!,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                if (deal.dealType != null) ...[
                  4.verticalSpace,
                  Text(
                    deal.dealType!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (deal.priceDisplay != null)
                Text(
                  deal.priceDisplay!,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              if (deal.websiteUrl != null)
                TextButton(
                  onPressed: () => _launchUrl(deal.websiteUrl!),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(60.w, 30.h),
                  ),
                  child: Text(
                    'View Deal',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open the URL',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
