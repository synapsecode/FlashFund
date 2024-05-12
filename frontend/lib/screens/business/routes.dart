import 'package:flutter/material.dart';
import 'package:frontend/screens/business/dashboard.dart';
import 'package:frontend/screens/business/login.dart';
import 'package:frontend/screens/business/onboarding.dart';
import 'package:frontend/screens/business/raisefundspage.dart';
import 'package:frontend/screens/business/repaylisting.dart';
import 'package:go_router/go_router.dart';

final businessRoutes = GoRoute(
  path: '/business',
  builder: (context, state) {
    if (state.fullPath == '/business') {
      context.go('/business/login'); //todo: change if authenticated
      return const SizedBox();
    }
    return const SizedBox();
  },
  routes: [
    GoRoute(
      path: 'login',
      builder: (context, state) => const BusinessLoginScreen(),
    ),
    GoRoute(
      path: 'onboarding',
      builder: (context, state) => const BusinessOnboardingScreen(),
    ),
    GoRoute(
      path: 'dashboard',
      builder: (context, state) => const BusinessDashboard(),
    ),
    GoRoute(
      path: 'startrepayment',
      builder: (context, state) => const RepayListingPage(),
    ),
    GoRoute(
      path: 'raisefunds',
      builder: (context, state) => const RaiseFundsPage(),
    ),
  ],
);
