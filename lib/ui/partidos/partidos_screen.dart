import 'package:club_libertad_front/ui/widgets/live_match.dart';
import 'package:club_libertad_front/ui/widgets/match_status.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:club_libertad_front/ui/widgets/tournBracker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PartidosScreen extends StatefulWidget {
  const PartidosScreen({super.key});

  @override
  State<PartidosScreen> createState() => _PartidosScreenState();
}

class _PartidosScreenState extends State<PartidosScreen>
    with SingleTickerProviderStateMixin {
  bool hayPartidosEnVivo = true; // cambiar con API
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  final List<List<MatchData>> _dummyRounds = [
    [
      MatchData(teamA: "Equipo A", teamB: "Equipo B", winner: "Equipo A"),
      MatchData(teamA: "Equipo C", teamB: "Equipo D", winner: "Equipo D"),
      MatchData(teamA: "Equipo E", teamB: "Equipo F", winner: "Equipo E"),
      MatchData(teamA: "Equipo G", teamB: "Equipo H", winner: "Equipo H"),
      MatchData(teamA: "Equipo I", teamB: "Equipo J", winner: "Equipo J"),
      MatchData(teamA: "Equipo K", teamB: "Equipo L", winner: "Equipo L"),
      MatchData(teamA: "Equipo M", teamB: "Equipo N", winner: "Equipo M"),
      MatchData(teamA: "Equipo O", teamB: "Equipo P", winner: "Equipo P"),
    ],
    // Segunda ronda (Semifinales)
    [
      MatchData(teamA: "Equipo A", teamB: "Equipo D", winner: "Equipo A"),
      MatchData(teamA: "Equipo E", teamB: "Equipo H", winner: "Equipo H"),
      MatchData(teamA: "Equipo J", teamB: "Equipo L", winner: "Equipo L"),
      MatchData(teamA: "Equipo M", teamB: "Equipo P", winner: "Equipo P"),
    ],
    // Tercera ronda (Final)
    [
      MatchData(teamA: "Equipo A", teamB: "Equipo H", winner: "Equipo H"),
      MatchData(teamA: "Equipo L", teamB: "Equipo P", winner: "Equipo L"),
    ],
    [
      MatchData(teamA: "Equipo L", teamB: "Equipo H", winner: "Equipo H"),
    ],
  ];

  Widget _buildCustomStatBox({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const SafeArea(
            child: TopBarClub(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Partidos',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Llaves y resultados de torneos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (hayPartidosEnVivo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.red[100],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _opacityAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: const Icon(Icons.circle,
                                    size: 10, color: Color(0xFFB91C1C)),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '2 partidos en vivo',
                            style: TextStyle(
                              color: Color(0xFFB91C1C),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sigue los partidos en tiempo real',
                        style: TextStyle(
                          color: Color(0xFFB91C1C),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ToggleFormSelector(
              options: const ['Llaves', 'Próximos', 'En vivo'],
              selectedIndex: _selectedTabIndex,
              onChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              selectedColor: Colors.white,
              selectedTextColor: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedTabIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '< Resultados / Partidos',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Copa X',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ciudad • (división - profesional, amateur, etc):',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (_selectedTabIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 2.5,
                  panEnabled: true,
                  child: TournamentBracket(rounds: _dummyRounds),
                ),
              ),
            ),

          if (_selectedTabIndex == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Fila principal
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/escudo.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Apellido Nombre',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Copa Primavera',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Semifinal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.black54),
                                SizedBox(width: 4),
                                Text('15 Jul, 4:00 PM',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.black54),
                                SizedBox(width: 4),
                                Text('Cancha Central',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botón Prepararse
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final parentContext =
                              context; // Guardamos el contexto externo

                          showDialog(
                            context: context,
                            builder: (dialogContext) => Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Preparación del partido',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Column(
                                        children: const [
                                          Text(
                                            'VS Juan Pérez',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Copa Primavera',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFF6FF),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: const [
                                                Text(
                                                  'Fecha',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                SizedBox(height: 6),
                                                Text(
                                                  '15/07/2025',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF0FDF4),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: const [
                                                Text(
                                                  'Hora',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                SizedBox(height: 6),
                                                Text(
                                                  '16:00',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Cancha: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Central Court',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Ronda: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Semifinal',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text(
                                              'Recordar',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              side: const BorderSide(
                                                  color: Colors.black12),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                            ),
                                            onPressed: () {
                                              // Cierra el dialog primero
                                              Navigator.of(dialogContext).pop();

                                              // Luego navega con el contexto original
                                              Future.microtask(() {
                                                parentContext.go('/perfil');
                                              });
                                            },
                                            child: const Text(
                                              'Estadísticas',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF243875),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          'Prepararse',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

// Botón rojo principal

          const SizedBox(height: 20),
          if (_selectedTabIndex == 0)
            ElevatedButton.icon(
              onPressed: () {
                print('Ver partido en vivo');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 95, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.visibility,
                color: Colors.white,
              ),
              label: const Text(
                'Ver tu partido en vivo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

          if (_selectedTabIndex == 0)
            const SizedBox(
              height: 10,
            ),
          if (_selectedTabIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.white,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.60,
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Estadísticas del torneo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Resumen general',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                _buildCustomStatBox(
                                                  label: 'Jugadores',
                                                  value: '64',
                                                  backgroundColor:
                                                      Color(0xFFE0F2F1),
                                                  textColor: Color(0xFF00695C),
                                                ),
                                                const SizedBox(width: 8),
                                                _buildCustomStatBox(
                                                  label: 'Partidos jugados',
                                                  value: '120',
                                                  backgroundColor:
                                                      Color(0xFFE8EAF6),
                                                  textColor: Color(0xFF1A237E),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                _buildCustomStatBox(
                                                  label: 'En vivo',
                                                  value: '2',
                                                  backgroundColor:
                                                      Color(0xFFFFEBEE),
                                                  textColor: Color(0xFFC62828),
                                                ),
                                                const SizedBox(width: 8),
                                                _buildCustomStatBox(
                                                  label: 'Programados',
                                                  value: '5',
                                                  backgroundColor:
                                                      Color(0xFFFFF3E0),
                                                  textColor: Color(0xFFEF6C00),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Duración de partidos',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text('Promedio:',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                Text('1h 15min',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text('Más largo:',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                Text('2h 10min',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text('Más corto:',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                Text('45min',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Cabezas de serie',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Column(
                                          children: List.generate(4, (index) {
                                            final numero = index + 1;
                                            final nombre =
                                                'Nombre Apellido $numero';

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFF2563EB),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      numero.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      nombre,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Text(
                                                      'Activo',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 20),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Sorpresas del torneo',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFF7ED),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Nombre Apellido (#12)',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF9A3412),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ' venció a ',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          'Nombre Apellido (#4)',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF9A3412),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                '2da ronda',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFFEA580C),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Tu rendimiento',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Color(
                                                0xFFEFF6FF), // Fondo celeste claro
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  // Número de ranking en fondo azul
                                                  Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFF2563EB),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      '12',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Nombre Apellido',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Partidos jugados:',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    '8',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Victorias:',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    '5',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Sets ganados:',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    '12',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Sets perdidos:',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    '6',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Estadísticas',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Descargar');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Descargar',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_selectedTabIndex == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LiveMatchCard(
                copa: 'Copa Primavera',
                marcador: '6-3, 4-6, 2-1',
                jugadorA: 'Juan Pérez',
                jugadorB: 'Carlos Gómez',
                cancha: 'Central Court',
                onVerPartido: () {
                  // Aquí rediriges o navegas a otra vista
                  // Navigator.pushNamed(context, '/verPartido');
                },
              ),
            ),

          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
