import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../core/constants/app_constants.dart';
import '../../core/utils/storage_manager.dart';
import '../models/hotel_model.dart';

/// Service class for handling all API calls related to hotels
/// Uses Dio HTTP client with authentication token and visitor token
class ApiService {
  late final Dio _dio;
  final StorageManager _storageManager = Get.find<StorageManager>();

  /// Initialize Dio with base URL, headers, and interceptors
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'authtoken': AppConstants.authToken,
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Add interceptor to inject visitor token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final visitorToken = _storageManager.getVisitorToken();
        if (visitorToken != null) {
          options.headers['visitortoken'] = visitorToken;
        }
        return handler.next(options);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  /// Internal POST method for making API calls with action parameter
  Future<Response> _post(String action, Map<String, dynamic> data) async {
    return await _dio.post(
      '',
      data: {
        'action': action,
        ...data,
      },
    );
  }

  /// Public POST method (used by DeviceService)
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await _dio.post(path, data: data);
  }

  /// Search hotels with detailed criteria
  ///
  /// [checkIn] - Check-in date (format: YYYY-MM-DD)
  /// [checkOut] - Check-out date (format: YYYY-MM-DD)
  /// [rooms] - Number of rooms (default: 1)
  /// [adults] - Number of adults (default: 2)
  /// [children] - Number of children (default: 0)
  /// [searchType] - Type of search (hotelIdSearch, citySearch, etc.)
  /// [searchQuery] - Search query array
  /// [accommodation] - Accommodation types filter
  /// [excludedSearchTypes] - Excluded search types (street, city, state, country)
  /// [highPrice] - Maximum price
  /// [lowPrice] - Minimum price
  /// [limit] - Number of results
  /// [currency] - Currency code
  ///
  /// Returns a Map containing:
  /// - hotels: List of HotelModel objects
  /// - total: Total number of results
  Future<Map<String, dynamic>> searchHotels({
    required String checkIn,
    required String checkOut,
    int rooms = 2,
    int adults = 2,
    int children = 0,
    String searchType = 'hotelIdSearch',
    List<String>? searchQuery,
    List<String>? accommodation,
    List<String>? excludedSearchTypes,
    String highPrice = '3000000',
    String lowPrice = '0',
    int limit = 10,
    String currency = 'INR',
    int rid = 0,
  }) async {
    try {
      final response = await _post('getSearchResultListOfHotels', {
        'getSearchResultListOfHotels': {
          'searchCriteria': {
            'checkIn': checkIn,
            'checkOut': checkOut,
            'rooms': rooms,
            'adults': adults,
            'children': children,
            'searchType': searchType,
            'searchQuery': searchQuery ?? [],
            'accommodation': accommodation ?? ['all'],
            'arrayOfExcludedSearchType': excludedSearchTypes ?? [],
            'highPrice': highPrice,
            'lowPrice': lowPrice,
            'limit': limit,
            'preloaderList': [],
            'currency': currency,
            'rid': rid,
          }
        },
      });

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];
        final List<dynamic> hotelsData = data['arrayOfHotelList'] ?? [];
        final List<HotelModel> hotels = hotelsData
            .map((json) => HotelModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return {
          'hotels': hotels,
          'total': hotels.length,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load hotels');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load hotels');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}
