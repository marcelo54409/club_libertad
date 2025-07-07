import 'package:club_libertad_front/ui/widgets/indicador.dart';
import 'package:club_libertad_front/ui/widgets/posicion_card.dart';
import 'package:club_libertad_front/ui/widgets/ranking_deportista_list.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:club_libertad_front/ui/widgets/torneo_data.dart';
import 'package:flutter/material.dart';
import 'package:club_libertad_front/ui/widgets/torneo_card_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TorneosScreen extends StatefulWidget {
  const TorneosScreen({super.key});

  @override
  State<TorneosScreen> createState() => _TorneosScreenState();
}

class _TorneosScreenState extends State<TorneosScreen> {
  String? selectedCiudad;
  String? selectedNivel;
  String? selectedSuperficie;
  int selectedEstadoIndex = 0;
  final List<String> estados = ['Abierto', 'En curso', 'Finalizado'];

  final ciudades = ['Trujillo', 'Lima', 'Piura'];
  final niveles = ['A', 'B', 'C'];
  final superficies = ['Césped', 'Arcilla', 'Dura'];
  final List<TorneoData> torneos = [
    TorneoData(
        titulo: 'Torneo Verano',
        categoria: 'Nivel A',
        nombre: "Club Lima",
        ciudad: 'Lima',
        fecha: '10 Jul 2025',
        monto: 'S/ 50',
        inscritos: 12,
        totalCupos: 20,
        puntos: 100,
        superficie: 'Césped',
        porcentaje: 60,
        estado: 'En curso'),
    TorneoData(
        titulo: 'Torneo Regional',
        categoria: 'Nivel B',
        nombre: "Club Trujillo",
        ciudad: 'Trujillo',
        fecha: '18 Jul 2025',
        monto: 'S/ 40',
        inscritos: 18,
        totalCupos: 25,
        puntos: 80,
        superficie: 'Arcilla',
        porcentaje: 72,
        estado: 'Abierto'),
  ];

  void _showFiltroDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Filtros de búsqueda'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ciudad',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedCiudad,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                items: ciudades.map((ciudad) {
                  return DropdownMenuItem(
                    value: ciudad,
                    child: Text(ciudad),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCiudad = value),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nivel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedNivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                items: niveles.map((nivel) {
                  return DropdownMenuItem(
                    value: nivel,
                    child: Text(nivel),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedNivel = value),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Superficie',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedSuperficie,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                items: superficies.map((superficie) {
                  return DropdownMenuItem(
                    value: superficie,
                    child: Text(superficie),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedSuperficie = value),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Aplicar filtros',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const TopBarClub(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Torneos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Encuentra y participa en torneos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, 
                        hintText: 'Buscar torneo...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide.none, 
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(8), 
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.filter, size: 20),
                      onPressed: _showFiltroDialog,
                      splashRadius: 24,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleFormSelector(
                    options: estados,
                    selectedIndex: selectedEstadoIndex,
                    onChanged: (index) {
                      setState(() {
                        selectedEstadoIndex = index;
                      });
                    },
                    selectedColor: Colors.white,
                    selectedTextColor: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  ...torneos
                      .where((t) =>
                          t.estado.toLowerCase() ==
                          estados[selectedEstadoIndex].toLowerCase())
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TorneoCard(t),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
