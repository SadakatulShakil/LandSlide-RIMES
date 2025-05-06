import 'package:lanslide_report/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserPrefService {
  // Singleton instance
  static final UserPrefService _instance = UserPrefService._internal();
  factory UserPrefService() => _instance;
  UserPrefService._internal();

  static const String _keyUserToken = 'TOKEN';
  static const String _keyUserRefresh = 'REFRESH';
  static const String _keyUserId = 'ID';
  static const String _keyUserEmail = 'EMAIL';
  static const String _keyUserName = 'NAME';
  static const String _keyUserMobile = 'MOBILE';
  static const String _keyUserAddress = 'ADDRESS';
  static const String _keyUserType = 'TYPE';
  static const String _keyUserPhoto = 'PHOTO';
  static const String _keyFcmToken = 'FCM';
  static const String _keyLat = 'LAT';
  static const String _keyLon = 'LON';
  static const String _keyLocationId = 'LOCATION_ID';
  static const String _keyLocationName = 'LOCATION_NAME';
  static const String _keyLocationUpazila = 'LOCATION_UPAZILA';
  static const String _keyLocationDistrict = 'LOCATION_DISTRICT';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Refresh access token
  Future<bool> refreshAccessToken() async {
    final refreshToken = _prefs?.getString(_keyUserRefresh);
    if (refreshToken == null) {
      print("No refresh token found, user needs to log in again.");
      return false;
    }

    try {
      var params = jsonEncode({
        "refresh": refreshToken,
        "device": "api"
      });
      var response = await http.post(ApiURL.refreshToken,
        headers: {
          "Content-Type": "application/json",
        },
        body: params);

      if (response.statusCode == 200) {
        dynamic decode = jsonDecode(response.body) ;
        String newAccessToken = decode['result']['token'];
        String newRefreshToken = decode['result']['token'] ?? refreshToken;

        // Save the new tokens
        await _prefs?.setString(_keyUserToken, newAccessToken);
        await _prefs?.setString(_keyUserRefresh, newRefreshToken);

        print("Token refreshed successfully.");
        return true;
      } else {
        print("Failed to refresh token: ${response.body}");
        await clearUserData();
        return false;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }

  // Save user data
  Future<void> saveUserData(
      String token,
      String refresh,
      String id,
      String name,
      String email,
      String mobile,
      String address,
      String type,
      String photo
      ) async {
    await _prefs?.setString(_keyUserToken, token);
    await _prefs?.setString(_keyUserRefresh, refresh);
    await _prefs?.setString(_keyUserId, id);
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserMobile, mobile);
    await _prefs?.setString(_keyUserAddress, address);
    await _prefs?.setString(_keyUserType, type);
    await _prefs?.setString(_keyUserPhoto, photo);
  }

  // Save firebase data
  Future<void> saveFireBaseData(
      String fcmToken
      ) async {
    await _prefs?.setString(_keyFcmToken, fcmToken);
  }

  Future<void> saveLocationData(
      String lat,
      String lon,
      String locationId,
      String locationName,
      String locationUpazila,
      String locationDistrict,
      ) async {
    await _prefs?.setString(_keyLat, lat);
    await _prefs?.setString(_keyLon, lon);
    await _prefs?.setString(_keyLocationId, locationId);
    await _prefs?.setString(_keyLocationName, locationName);
    await _prefs?.setString(_keyLocationUpazila, locationUpazila);
    await _prefs?.setString(_keyLocationDistrict, locationDistrict);
  }

  // Update user data
  Future<void> updateUserData(
      String name,
      String email,
      String address,
      String type,
      ) async {
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserAddress, address);
    await _prefs?.setString(_keyUserType, type);
  }

  // Update user data
  Future<void> updateUserPhoto(String url) async {
  await _prefs?.setString(_keyUserPhoto, url);
  }


  // Get user Token
  String? get userToken => _prefs?.getString(_keyUserToken);

  // Get user refresh
  String? get refreshToken => _prefs?.getString(_keyUserRefresh);

  // Get user id
  String? get userId => _prefs?.getString(_keyUserId);

  // Get user name
  String? get userName => _prefs?.getString(_keyUserName);

  // Get user email
  String? get userEmail => _prefs?.getString(_keyUserEmail);

  // Get user mobile
  String? get userMobile => _prefs?.getString(_keyUserMobile);

  // Get user address
  String? get userAddress => _prefs?.getString(_keyUserAddress);

  // Get user type
  String? get userType => _prefs?.getString(_keyUserType);

  // Get user photo
  String? get userPhoto => _prefs?.getString(_keyUserPhoto);

  // Get user fcm
  String? get fcmToken => _prefs?.getString(_keyFcmToken);

  // Get user lat
  String? get lat => _prefs?.getString(_keyLat);

  // Get user lon
  String? get lon => _prefs?.getString(_keyLon);

  // Get user locationId
  String? get locationId => _prefs?.getString(_keyLocationId);

  // Get user locationName
  String? get locationName => _prefs?.getString(_keyLocationName);

  // Get user locationUpazila
  String? get locationUpazila => _prefs?.getString(_keyLocationUpazila);

  // Get user locationDistrict
  String? get locationDistrict => _prefs?.getString(_keyLocationDistrict);


  // Clear user data (logout)
  Future<void> clearUserData() async {
    await _prefs?.remove(_keyUserToken);
    await _prefs?.remove(_keyUserId);
    await _prefs?.remove(_keyUserName);
    await _prefs?.remove(_keyUserEmail);
    await _prefs?.remove(_keyUserMobile);
    await _prefs?.remove(_keyUserAddress);
    await _prefs?.remove(_keyUserType);
    await _prefs?.remove(_keyUserPhoto);
  }
}