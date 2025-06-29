import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeShellScreen extends StatelessWidget {
  final Widget child;

  const HomeShellScreen({super.key, required this.child});

  static const List<String> _routes = [
    '/inicio',
    '/torneos',
    '/ranking',
    '/partidos',
    '/perfil',
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _routes.indexWhere((r) => location.startsWith(r));

    final icons = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.trophy,
      FontAwesomeIcons.chartLine,
      FontAwesomeIcons.tableTennisPaddleBall,
      FontAwesomeIcons.user,
    ];

    final labels = ['Inicio', 'Torneos', 'Ranking', 'Partidos', 'Perfil'];

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_routes.length, (index) {
            final bool isActive = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => context.go(_routes[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.black12.withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        icons[index],
                        size: 20,
                        color: Colors.black54,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
