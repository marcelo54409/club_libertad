import 'package:club_libertad_front/ui/widgets/info_card_widget.dart';
import 'package:club_libertad_front/ui/widgets/partido_reciente.dart';
import 'package:club_libertad_front/ui/widgets/perfil_usuario_card.dart';
import 'package:club_libertad_front/ui/widgets/rendimiento_card.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int selectedToggleIndex = 0;

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
        child: Column(
          children: [
            // Card de perfil con padding
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PerfilUsuarioCard(
                imageUrl: 'assets/images/escudo.png',
                nombre: 'Andrei',
                apellido: 'Pérez',
                ciudad: 'Lima',
                pais: 'Perú',
                ranking: 3,
                puntos: 2150,
                torneos: 12,
                titulos: 3,
                victorias: 25,
                winrate: 85.5,
                onEdit: () => print('Editar perfil'),
              ),
            ),

            // Primera fila de tarjetas con margen lateral
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: InfoCardWidget(
                      titulo: 'Ranking',
                      numero: '#5',
                      icono: FontAwesomeIcons.trophy,
                      colorFondo: const Color.fromRGBO(224, 9, 27, 0.8),
                      colorTexto: const Color(0xFFFECACA),
                      onTap: () => print('Card tocado'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCardWidget(
                      titulo: 'Puntos',
                      numero: '8',
                      icono: FontAwesomeIcons.star,
                      colorFondo: const Color.fromRGBO(36, 56, 117, 0.8),
                      colorTexto: const Color(0xFFBFDBFE),
                      onTap: () => print('Card tocado'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Segunda fila de tarjetas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: InfoCardWidget(
                      titulo: 'Torneos',
                      numero: '25',
                      icono: FontAwesomeIcons.calendar,
                      colorFondo: const Color.fromRGBO(175, 157, 84, 0.8),
                      colorTexto: const Color(0xFFFEF08A),
                      onTap: () => print('Card tocado'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCardWidget(
                      titulo: 'Win Rate',
                      numero: '85.5%',
                      icono: FontAwesomeIcons.arrowTrendUp,
                      colorTexto: const Color(0xFFFECACA),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE0091B),
                          Color(0xFF243875),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => print('Card tocado'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Card de rendimiento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: RendimientoCardWidget(
                victorias: 25,
                derrotas: 5,
              ),
            ),

            const SizedBox(height: 12),

            // Toggle de vista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ToggleFormSelector(
                options: const ['Partidos', 'Logros'],
                selectedIndex: selectedToggleIndex,
                onChanged: (index) {
                  setState(() {
                    selectedToggleIndex = index;
                  });
                },
                selectedColor: Colors.white,
                selectedTextColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

// Título dinámico según el toggle seleccionado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedToggleIndex == 0
                        ? 'Partidos Recientes'
                        : 'Logros Recientes',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print('Ver todos presionado');
                      // Puedes navegar a una pantalla detallada si deseas
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Ver Todos',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),

            if (selectedToggleIndex == 0) ...[
              const SizedBox(height: 8),
              PartidoRecienteCard(
                nombreCompleto: 'Rafael Nadal',
                liga: 'ATP 250 - Doha',
                fecha: DateTime(2025, 3, 12),
                esVictoria: true,
                marcador: '6‑4 3‑6 7‑6',
              ),
              PartidoRecienteCard(
                nombreCompleto: 'Rafael Nadal',
                liga: 'ATP 250 - Doha',
                fecha: DateTime(2025, 3, 12),
                esVictoria: false,
                marcador: '6‑4 3‑6 7‑6',
              ),
              // más partidos...
            ] else ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ícono con fondo circular
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const FaIcon(
                            FontAwesomeIcons.trophy,
                            size: 20,
                            color: Color.fromRGBO(202, 138, 4, 1),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Contenido a la derecha
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Campeón Nacional',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Torneo Nacional de Verano',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.clock,
                                    size: 12,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Marzo 2024',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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
              )
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    bool push = true;
                    bool email = false;
                    bool publico = true;
                    bool oscuro = false;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Configuración',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildConfigRow(
                                  label: 'Notificación Push',
                                  value: push,
                                  onChanged: (val) =>
                                      setState(() => push = val ?? false),
                                ),
                                _buildConfigRow(
                                  label: 'Notificación por Email',
                                  value: email,
                                  onChanged: (val) =>
                                      setState(() => email = val ?? false),
                                ),
                                _buildConfigRow(
                                  label: 'Perfil Público',
                                  value: publico,
                                  onChanged: (val) =>
                                      setState(() => publico = val ?? false),
                                ),
                                _buildConfigRow(
                                  label: 'Modo Oscuro',
                                  value: oscuro,
                                  onChanged: (val) =>
                                      setState(() => oscuro = val ?? false),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      print('Configuración guardada');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Guardar configuración',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.gear,
                size: 16,
                color: Colors.black,
              ),
              label: const Text('Configuración de Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged, // <-- aquí el cambio
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
