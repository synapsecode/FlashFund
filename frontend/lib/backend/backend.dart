import 'package:flutter/material.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/main.dart';
import 'package:frontend/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SERVER = "http://192.168.171.174:3000";

loadAllControllers() async {
  final prefs = await SharedPreferences.getInstance();
  final business_user_id = prefs.getInt('business_user_id');
  final investor_user_id = prefs.getInt('investor_user_id');

  if (business_user_id == null && investor_user_id == null) {
    print('NO LOGIN STATE');
  } else {
    if (business_user_id != null) {
      gpc.read(businessUserIDProvider.notifier).state = business_user_id;
      navigatorKey.currentState!.context.go('/business/dashboard');
    } else {
      gpc.read(investorUserIDProvider.notifier).state = investor_user_id;
      navigatorKey.currentState!.context.go('/investor/dashboard');
    }
  }
}

logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  gpc.invalidate(businessUserIDProvider);
  gpc.invalidate(investorUserIDProvider);
  context.go('/');
}
