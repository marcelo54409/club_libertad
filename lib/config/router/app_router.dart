import 'package:club_libertad_front/config/router/app_router_notifier.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/check_auth_status.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterProviderS);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            const MaterialPage(child: CheckAuthStatus()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.path;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.cheking) {
        return null;
      }
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login') {
          return null;
        } else {
          return '/login';
        }
      }
      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash') {
          return '/form-sucursal'; // Redirige al SucursalScreen
        } else {
          return null;
        }
      }

      return null;
    },
  );
});
