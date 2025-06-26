import 'package:club_libertad_front/features/shared/infrastructure/services/sync_service.dart';
import 'package:flutter/material.dart';


import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'config/constants/environment.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:loader_overlay/loader_overlay.dart';


Future<void> main() async {
  await Environment.initEnvironment();
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

 

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider);
    final appRouter = ref.watch(goRouterProvider);
    final connectivityStatus = ref.watch(connectivityProvider);

    return GlobalLoaderOverlay(
      duration: Durations.medium4,
      reverseDuration: Durations.medium4,
      overlayColor: Colors.grey.withOpacity(0.8),
      overlayWidgetBuilder: (_) {
        // Ignorar el progreso por el momento
        return const Center(
          child: SpinKitCubeGrid(
            color: Colors.white,
            size: 50.0,
          ),
        );
      },
      child: MaterialApp.router(
        theme: theme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: child!,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height:
                    connectivityStatus == ConnectivityStatus.offline ? 50 : 0,
                child: connectivityStatus == ConnectivityStatus.offline
                    ? Container(
                        width: double.infinity,
                        color: theme.primaryColor,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Modo offline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
