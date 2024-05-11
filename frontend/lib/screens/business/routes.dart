import 'package:flutter/material.dart';
import 'package:frontend/screens/business/login.dart';
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
  ],
);
