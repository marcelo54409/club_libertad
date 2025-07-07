import 'package:club_libertad_front/config/router/app_router_notifier.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/check_auth_status.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/login_screen.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/splash_screen.dart';
import 'package:club_libertad_front/ui/inicio/inicio_screen.dart';
import 'package:club_libertad_front/ui/ranking/ranking_screen.dart';
import 'package:club_libertad_front/ui/torneos/torneos_screen.dart';
import 'package:club_libertad_front/ui/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterProviderS);
  return GoRouter(
    initialLocation: '/splashScreen',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splashScreen',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
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

      // Este es el wrapper que contiene el BottomNavigationBar
      ShellRoute(
        builder: (context, state, child) {
          return HomeShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/inicio',
            builder: (context, state) => InicioScreen(),
          ),
          GoRoute(
            path: '/ranking',
            builder: (context, state) => RankingScreen(),
          ),
          GoRoute(
            path: '/torneos',
            builder: (context, state) => TorneosScreen(),
          ),
          /*
          GoRoute(
            path: '/partidos',
            builder: (context, state) => const PartidosScreen(),
          ),
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilScreen(),
          ),*/
        ],
      ),
    ],
    redirect: (context, state) {
      return null; // <<-- permite pasar a cualquier ruta sin bloquear por auth

      /*final isGoingTo = state.uri.path;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.cheking)
        return null;
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login') return null;
        return '/login';
      }
      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash') {
          return '/inicio'; // <-- Redirige al home dentro del shell
        }
      }
      return null;*/
    },
  );
});
