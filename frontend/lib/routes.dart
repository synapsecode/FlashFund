import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/business/routes.dart';
import 'package:frontend/screens/investor/routes.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final globalRouter = GoRouter(
  // initialLocation: '/enterprise/onboarding/1000',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FlashFundApp(),
    ),
    businessRoutes,
    investorRoutes,
  ],
);

checkIfUserAuthenticated() {
  //TODO: implementation pending
  return true;
  // final jwt = gpc.read(jwtTokenProvider);
  // return (jwt != null);
}
