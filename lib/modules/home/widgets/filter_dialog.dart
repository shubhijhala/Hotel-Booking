import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Filter content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date pickers
                    _buildSectionTitle('Check-in & Check-out'),
                    12.verticalSpace,
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                context: context,
                                label: 'Check-in',
                                date: controller.checkInDate.value,
                                onTap: () => controller.selectCheckInDate(context),
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: _buildDateField(
                                context: context,
                                label: 'Check-out',
                                date: controller.checkOutDate.value,
                                onTap: () => controller.selectCheckOutDate(context),
                              ),
                            ),
                          ],
                        )),
                    24.verticalSpace,

                    // Guest inputs
                    _buildSectionTitle('Guests & Rooms'),
                    12.verticalSpace,
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: _buildNumberInput(
                                label: 'Rooms',
                                value: controller.rooms.value,
                                onChanged: (val) => controller.rooms.value = val,
                              ),
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: _buildNumberInput(
                                label: 'Adults',
                                value: controller.adults.value,
                                onChanged: (val) => controller.adults.value = val,
                              ),
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: _buildNumberInput(
                                label: 'Children',
                                value: controller.children.value,
                                onChanged: (val) => controller.children.value = val,
                              ),
                            ),
                          ],
                        )),
                    24.verticalSpace,

                    // Accommodation type
                    _buildSectionTitle('Accommodation Type'),
                    12.verticalSpace,
                    _buildDropdownSection(
                      items: controller.accommodationTypes,
                      selectedItems: controller.selectedAccommodation,
                      onToggle: controller.toggleAccommodation,
                    ),
                    24.verticalSpace,

                    // Excluded search types
                    _buildSectionTitle('Exclude Search By'),
                    12.verticalSpace,
                    _buildDropdownSection(
                      items: controller.excludedTypeOptions,
                      selectedItems: controller.excludedSearchTypes,
                      onToggle: controller.toggleExcludedSearchType,
                    ),
                    24.verticalSpace,

                    // Price range
                    _buildSectionTitle('Price Range'),
                    12.verticalSpace,
                    Obx(() => Column(
                          children: [
                            RangeSlider(
                              values: RangeValues(
                                controller.minPrice.value,
                                controller.maxPrice.value,
                              ),
                              min: 0,
                              max: 3000000,
                              divisions: 100,
                              labels: RangeLabels(
                                '₹${controller.minPrice.value.toStringAsFixed(0)}',
                                '₹${controller.maxPrice.value.toStringAsFixed(0)}',
                              ),
                              onChanged: (values) {
                                controller.updatePriceRange(values.start, values.end);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${controller.minPrice.value.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                Text(
                                  '₹${controller.maxPrice.value.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),

            // Apply button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.loadHotels();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            4.verticalSpace,
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                8.horizontalSpace,
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          4.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: value > 0 ? () => onChanged(value - 1) : null,
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 18,
                  color: value > 0 ? AppColors.primary : Colors.grey,
                ),
              ),
              8.horizontalSpace,
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              8.horizontalSpace,
              InkWell(
                onTap: () => onChanged(value + 1),
                child: const Icon(
                  Icons.add_circle_outline,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection({
    required List<String> items,
    required RxList<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return InkWell(
              onTap: () => onToggle(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }
}
