import 'package:flutter/material.dart';
import 'package:frontend/screens/business/login.dart';
import 'package:frontend/screens/investor/currentroadshows.dart';
import 'package:frontend/screens/investor/dashboard.dart';
import 'package:frontend/screens/investor/ipo_marketplace.dart';
import 'package:frontend/screens/investor/login.dart';
import 'package:frontend/screens/investor/onboarding.dart';
import 'package:go_router/go_router.dart';

final investorRoutes = GoRoute(
  path: '/investor',
  builder: (context, state) {
    if (state.fullPath == '/investor') {
      context.go('/investor/login'); //todo: change if authenticated
      return const SizedBox();
    }
    return const SizedBox();
  },
  routes: [
    GoRoute(
      path: 'login',
      builder: (context, state) => const InvestorLoginScreen(),
    ),
    GoRoute(
      path: 'onboarding',
      builder: (context, state) => const InvestorOnboardingScreen(),
    ),
    GoRoute(
      path: 'dashboard',
      builder: (context, state) => const InvestorDashboard(),
    ),
    GoRoute(
      path: 'roadshows',
      builder: (context, state) => const CurrentRoadshowsPage(),
    ),
    GoRoute(
      path: 'marketplace',
      builder: (context, state) => const IPOMarketplacePage(),
    ),
  ],
);
