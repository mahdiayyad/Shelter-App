import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Session.dart';

/// Values are stored in storage of mobile to keep track of a user has logged in, user profiles
class SharedPreferencesManager {
  late SharedPreferences prefs;
  Future<SharedPreferencesManager> initState() async {
    prefs = await SharedPreferences.getInstance();
    await getUserType();
    return this;
  }

  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();
  factory SharedPreferencesManager() => _instance;
  SharedPreferencesManager._internal() {
    initState();
  }

  // Future<String?> getToken() async {
  //   return Session.mToken = await getString('Token');
  // }

  // void setToken(String? token) {
  //   Session.mToken = token;
  //   setString('Token', token);
  // }

  /// Retrieve the userType
  Future<UserType> getUserType() async {
    UserType userType = EnumToString.fromString<UserType>(
            UserType.values, await getString('UserType') ?? '') ??
        UserType.customer;
    return Session.userType = userType;
  }

  /// save the userType
  void setUserType(UserType userType) {
    Session.userType = userType;
    setString('UserType', EnumToString.convertToString(userType));
  }

  /// Save a value
  void setString(String key, String? value) {
    if (value == null) {
      prefs.remove(key);
      return;
    }
    prefs.setString(key, value);
  }

  /// Retrieve value later
  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }
  
}
