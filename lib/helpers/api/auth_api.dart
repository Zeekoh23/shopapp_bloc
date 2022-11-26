import 'dart:convert';
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../../models/products.dart';
import '../api.dart';
import '../../models/orders.dart';
import '../../models/cart.dart';
import '../api_route.dart';

class AuthApi {
  var log = Logger();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? _token;
  DateTime? _expiryDate;
  String? userId;
  String? _email;
  Timer? _authTimer;
  bool get isAuth {
    if (_token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  String get token {
    if (_token != '') {
      return _token!;
    }
    return '';
  }

  String get email {
    return _email!;
  }

//auth request
  Future<ResponseApi> login(String email, String password) async {
    final response = await Api.postRequest(
      ApiRoute.loginUrl,
      {
        'email': email,
        'password': password,
      },
    );
    final responseData = json.decode(response.body);
    // if (responseData['error'] != null) {
    if (response.statusCode == 200) {
      _token = responseData['token'];
      userId = responseData['data']['user']['_id'];
      _expiryDate = DateTime.now().add(
        const Duration(seconds: 6000000),
      );
      _email = responseData['data']['user']['email'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'userId': userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'email': _email,
        },
      );
      prefs.setString('userData', userData);

      _autoLogout();
      return ResponseApi(
        status: true,
        message: 'Login Successful',
        data: responseData,
      );
    }
    return ResponseApi(
      status: false,
      message: responseData['message'],
    );
    // }
  }

  Future<ResponseApi> signup(
    String email,
    String password,
    String passwordConfirm,
  ) async {
    final response = await Api.postRequest(
      ApiRoute.signupUrl,
      {
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode != 400 || response.statusCode != 500) {
      _token = responseData['token'];
      userId = responseData['data']['user']['_id'];
      _expiryDate = DateTime.now().add(
        const Duration(seconds: 6000000),
      );
      _email = responseData['data']['user']['email'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'userId': userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'email': _email,
        },
      );
      prefs.setString('userData', userData);

      _autoLogout();
      return ResponseApi(
        status: true,
        message: 'Login Successful',
        data: responseData,
      );
    }
    return ResponseApi(
      status: false,
      message: responseData['message'],
    );
  }

  Future<void> persistToken(String token) async {
    await storage.write(
      key: 'token',
      value: token,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
