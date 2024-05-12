import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/backend.dart';
import 'package:frontend/backend/interceptor.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final investorUserIDProvider = StateProvider<int?>((ref) => null);
final businessUserIDProvider = StateProvider<int?>((ref) => null);

class BusinessAuth {
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };
    final res = await interceptor.post(
      '$SERVER/business/login',
      body: body,
    );
    if (res['success'] == true) {
      gpc.read(businessUserIDProvider.notifier).state = res['id']!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('business_user_id', res['id']);
      print('Business Login Successful!');
      return true;
    }
    return false;
  }

  static Future<bool> register({
    required String email,
    required String password,
    required String companyName,
    required String legalstructure,
    required String companyAddress,
    required String fundingStatus,
  }) async {
    final dT = DateTime.now();
    final body = {
      "company_name": companyName,
      "legalstructure": legalstructure,
      "company_address": companyAddress,
      "dateoffounding":
          "${dT.day.numericPad(width: 2)}/${dT.month.numericPad(width: 2)}/${dT.year.numericPad(width: 2)}",
      "email": email,
      "password": password,
      "funding_state": fundingStatus,
    };
    final res = await interceptor.post(
      '$SERVER/business/register',
      body: body,
    );
    if (res['status'] == 'OK') {
      return true;
    }
    return false;
  }
}

class InvestorAuth {
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };
    final res = await interceptor.post(
      '$SERVER/investor/login',
      body: body,
    );
    if (res['success'] == true) {
      gpc.read(investorUserIDProvider.notifier).state = res['id']!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('investor_user_id', res['id']);
      print('Investor Login Successful!');
      return true;
    }
    return false;
  }

  static Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String aadhar,
    required String address,
    required String pan,
  }) async {
    final body = {
      "name": name,
      "aadhar": aadhar,
      "address": address,
      "email": email,
      "password": password,
      "pan": pan,
    };
    final res = await interceptor.post(
      '$SERVER/investor/register',
      body: body,
    );
    if (res['status'] == 'OK') {
      return true;
    }
    return false;
  }
}
