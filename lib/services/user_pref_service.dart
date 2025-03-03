import 'package:shared_preferences/shared_preferences.dart';

class UserPrefService {
  // Singleton instance
  static final UserPrefService _instance = UserPrefService._internal();
  factory UserPrefService() => _instance;
  UserPrefService._internal();

  static const String _keyUserToken = 'TOKEN';
  static const String _keyUserId = 'ID';
  static const String _keyUserEmail = 'EMAIL';
  static const String _keyUserName = 'NAME';
  static const String _keyUserMobile = 'MOBILE';
  static const String _keyUserAddress = 'ADDRESS';
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

  // Save user data
  Future<void> saveUserData(
      String token,
      String id,
      String name,
      String email,
      String mobile,
      String address,
      String photo
      ) async {
    await _prefs?.setString(_keyUserToken, token);
    await _prefs?.setString(_keyUserId, id);
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserMobile, mobile);
    await _prefs?.setString(_keyUserAddress, address);
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
      ) async {
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserAddress, address);
  }


  // Get user Token
  String? get userToken => _prefs?.getString(_keyUserToken);

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
    await _prefs?.remove(_keyUserPhoto);
  }
}