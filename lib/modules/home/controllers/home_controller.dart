import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/hotel_model.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_routes.dart';

/// Controller for Home Page
/// Handles hotel search with comprehensive filters
class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final TextEditingController searchTextController = TextEditingController();

  final RxList<HotelModel> hotels = <HotelModel>[].obs;
  final RxList<HotelModel> allHotels = <HotelModel>[].obs; // Store all hotels
  final RxList<HotelModel> filteredHotels = <HotelModel>[].obs; // Filtered hotels for display
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;

  final ScrollController scrollController = ScrollController();

  // Search Criteria
  final Rx<DateTime> checkInDate = DateTime.now().obs;
  final Rx<DateTime> checkOutDate = DateTime.now().add(const Duration(days: 1)).obs;
  final RxInt rooms = 2.obs;
  final RxInt adults = 2.obs;
  final RxInt children = 0.obs;

  // Accommodation filter
  final RxList<String> selectedAccommodation = <String>['all'].obs;
  final accommodationTypes = [
    'all',
    'hotel',
    'resort',
    'Boat House',
    'bedAndBreakfast',
    'guestHouse',
    'Holidayhome',
    'cottage',
    'apartment',
    'Home Stay',
    'hostel',
    'Guest House',
    'Camp_sites/tent',
    'co_living',
    'Villa',
    'Motel',
    'Capsule Hotel',
    'Dome Hotel',
  ];

  // Search query
  final RxString searchQuery = ''.obs;
  final RxList<String> searchQueryList = <String>['qyhZqzVt'].obs;

  // Excluded search types
  final RxList<String> excludedSearchTypes = <String>[].obs;
  final excludedTypeOptions = ['street', 'city', 'state', 'country'];

  // Price range
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 3000000.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load some random hotels initially
    loadInitialHotels();
    // Setup pagination scroll listener
    scrollController.addListener(_onScroll);
  }

  /// Scroll listener for pagination
  /// Triggers loadMore() when user scrolls near bottom
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value &&
          !isLoading.value &&
          currentPage.value < totalPages.value) {
        loadMore();
      }
    }
  }

  /// Load initial hotels using searchHotels API
  Future<void> loadInitialHotels() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = 1;

      // Format dates
      final checkIn = '${checkInDate.value.year}-${checkInDate.value.month.toString().padLeft(2, '0')}-${checkInDate.value.day.toString().padLeft(2, '0')}';
      final checkOut = '${checkOutDate.value.year}-${checkOutDate.value.month.toString().padLeft(2, '0')}-${checkOutDate.value.day.toString().padLeft(2, '0')}';

      final result = await _apiService.searchHotels(
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms.value,
        adults: adults.value,
        children: children.value,
        searchType: 'hotelIdSearch',
        searchQuery: searchQueryList.isNotEmpty ? searchQueryList : ['qyhZqzVt'],
        accommodation: selectedAccommodation.isNotEmpty ? selectedAccommodation : ['all'],
        excludedSearchTypes: excludedSearchTypes.isNotEmpty ? excludedSearchTypes : null,
        highPrice: maxPrice.value.toStringAsFixed(0),
        lowPrice: minPrice.value.toStringAsFixed(0),
        limit: 5,
      );

      final hotelList = result['hotels'] as List<HotelModel>;
      allHotels.value = hotelList;
      filteredHotels.value = hotelList;
      hotels.value = hotelList;

      // Set pagination info - if we got 5 results, there might be more
      totalPages.value = hotelList.length >= 5 ? currentPage.value + 1 : currentPage.value;
    } catch (e) {
      errorMessage.value = e.toString();
      allHotels.value = [];
      filteredHotels.value = [];
      hotels.value = [];
      totalPages.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more hotels for pagination using searchHotels API
  /// Makes another API call to get the next batch of results
  Future<void> loadMore() async {
    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      // Format dates
      final checkIn = '${checkInDate.value.year}-${checkInDate.value.month.toString().padLeft(2, '0')}-${checkInDate.value.day.toString().padLeft(2, '0')}';
      final checkOut = '${checkOutDate.value.year}-${checkOutDate.value.month.toString().padLeft(2, '0')}-${checkOutDate.value.day.toString().padLeft(2, '0')}';

      final result = await _apiService.searchHotels(
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms.value,
        adults: adults.value,
        children: children.value,
        searchType: 'hotelIdSearch',
        searchQuery: searchQueryList.isNotEmpty ? searchQueryList : ['qyhZqzVt'],
        accommodation: selectedAccommodation.isNotEmpty ? selectedAccommodation : ['all'],
        excludedSearchTypes: excludedSearchTypes.isNotEmpty ? excludedSearchTypes : null,
        highPrice: maxPrice.value.toStringAsFixed(0),
        lowPrice: minPrice.value.toStringAsFixed(0),
        limit: 5,
      );

      final hotelList = result['hotels'] as List<HotelModel>;

      if (hotelList.isNotEmpty) {
        allHotels.addAll(hotelList);
        filteredHotels.addAll(hotelList);
        hotels.addAll(hotelList);

        // If we got less than 5 results, we've reached the end
        if (hotelList.length < 5) {
          totalPages.value = currentPage.value;
        } else {
          totalPages.value = currentPage.value + 1;
        }
      } else {
        // No more results
        totalPages.value = currentPage.value;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Load hotels from API with current search criteria
  Future<void> loadHotels() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates
      final checkIn = '${checkInDate.value.year}-${checkInDate.value.month.toString().padLeft(2, '0')}-${checkInDate.value.day.toString().padLeft(2, '0')}';
      final checkOut = '${checkOutDate.value.year}-${checkOutDate.value.month.toString().padLeft(2, '0')}-${checkOutDate.value.day.toString().padLeft(2, '0')}';

      // If no search query provided, use a default hotel ID
      List<String> queryList = searchQueryList.isNotEmpty
          ? searchQueryList
          : ['qyhZqzVt']; // Default hotel ID

      final result = await _apiService.searchHotels(
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms.value,
        adults: adults.value,
        children: children.value,
        searchType: 'hotelIdSearch',
        searchQuery: queryList,
        accommodation: selectedAccommodation.isNotEmpty ? selectedAccommodation : ['all'],
        excludedSearchTypes: excludedSearchTypes.isNotEmpty ? excludedSearchTypes : null,
        highPrice: maxPrice.value.toStringAsFixed(0),
        lowPrice: minPrice.value.toStringAsFixed(0),
        limit: 5,
      );

      final hotelList = result['hotels'] as List<HotelModel>;
      allHotels.value = hotelList;
      filteredHotels.value = hotelList;
      hotels.value = hotelList;
    } catch (e) {
      errorMessage.value = e.toString();
      allHotels.value = [];
      filteredHotels.value = [];
      hotels.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Update check-in date
  Future<void> selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != checkInDate.value) {
      checkInDate.value = picked;
      // Ensure checkout is after checkin
      if (checkOutDate.value.isBefore(picked) || checkOutDate.value.isAtSameMomentAs(picked)) {
        checkOutDate.value = picked.add(const Duration(days: 1));
      }
      loadHotels();
    }
  }

  /// Update check-out date
  Future<void> selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate.value,
      firstDate: checkInDate.value.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != checkOutDate.value) {
      checkOutDate.value = picked;
      loadHotels();
    }
  }

  /// Toggle accommodation type selection
  void toggleAccommodation(String type) {
    if (type == 'all') {
      selectedAccommodation.clear();
      selectedAccommodation.add('all');
    } else {
      selectedAccommodation.remove('all');
      if (selectedAccommodation.contains(type)) {
        selectedAccommodation.remove(type);
      } else {
        selectedAccommodation.add(type);
      }
      if (selectedAccommodation.isEmpty) {
        selectedAccommodation.add('all');
      }
    }
    loadHotels();
  }

  /// Toggle excluded search type
  void toggleExcludedSearchType(String type) {
    if (excludedSearchTypes.contains(type)) {
      excludedSearchTypes.remove(type);
    } else {
      excludedSearchTypes.add(type);
    }
    loadHotels();
  }

  /// Update price range
  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  /// Apply price filter
  void applyPriceFilter() {
    loadHotels();
  }

  /// Perform local filtering on home page as user types
  /// NO API CALLS - just filter existing hotels by name, city, state
  void performAutoSearch(String query) {
    if (query.trim().isEmpty) {
      // Show all hotels
      filteredHotels.value = allHotels;
      return;
    }

    // Filter locally by name, city, or state
    final searchLower = query.toLowerCase();
    filteredHotels.value = allHotels.where((hotel) {
      final nameMatch = hotel.name.toLowerCase().contains(searchLower);
      final cityMatch = hotel.city?.toLowerCase().contains(searchLower) ?? false;
      final stateMatch = hotel.state?.toLowerCase().contains(searchLower) ?? false;
      return nameMatch || cityMatch || stateMatch;
    }).toList();
  }

  /// Clear search query
  void clearSearch() {
    searchQuery.value = '';
    searchTextController.clear();
    filteredHotels.value = allHotels;
  }

  @override
  Future<void> refresh() async {
    // Clear search query on refresh
    searchQuery.value = '';
    searchTextController.clear();
    await loadInitialHotels();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
