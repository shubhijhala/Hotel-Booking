import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../utils/storage_manager.dart';

/// Service for handling device registration and visitor token
class DeviceService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageManager _storageManager = Get.find<StorageManager>();

  /// Register device and get visitor token
  Future<String?> registerDevice() async {
    try {
      // Check if visitor token already exists
      if (_storageManager.hasVisitorToken()) {
        final token = _storageManager.getVisitorToken();
        debugPrint('DeviceService: Using existing visitor token: $token');
        return token;
      }

      // Get device information
      final deviceInfo = await _getDeviceInfo();

      // Register device with API
      final response = await _apiService.post(
        '',
        data: {
          'action': 'deviceRegister',
          'deviceRegister': deviceInfo,
        },
      );

      if (response.data['status'] == true &&
          response.data['data']?['visitorToken'] != null) {
        final visitorToken = response.data['data']['visitorToken'] as String;
        await _storageManager.saveVisitorToken(visitorToken);
        debugPrint('DeviceService: Device registered successfully. Token: $visitorToken');
        return visitorToken;
      } else {
        debugPrint('DeviceService: Device registration failed: ${response.data['message']}');
        return null;
      }
    } catch (e) {
      debugPrint('DeviceService: Error registering device: $e');
      return null;
    }
  }

  /// Get device information based on platform
  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return {
        'deviceModel': androidInfo.model,
        'deviceFingerprint': androidInfo.fingerprint,
        'deviceBrand': androidInfo.brand,
        'deviceId': androidInfo.id,
        'deviceName': '${androidInfo.model}_${androidInfo.version.sdkInt}_${androidInfo.version.release}',
        'deviceManufacturer': androidInfo.manufacturer,
        'deviceProduct': androidInfo.product,
        'deviceSerialNumber': androidInfo.serialNumber.isNotEmpty
            ? androidInfo.serialNumber
            : 'unknown',
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return {
        'deviceModel': iosInfo.model,
        'deviceFingerprint': iosInfo.identifierForVendor ?? '',
        'deviceBrand': 'Apple',
        'deviceId': iosInfo.identifierForVendor ?? 'unknown',
        'deviceName': '${iosInfo.model}_${iosInfo.systemVersion}',
        'deviceManufacturer': 'Apple',
        'deviceProduct': iosInfo.utsname.machine,
        'deviceSerialNumber': 'unknown',
      };
    }

    // Return empty map for unsupported platforms
    return {};
  }

  /// Get current visitor token
  String? getVisitorToken() {
    return _storageManager.getVisitorToken();
  }
}
