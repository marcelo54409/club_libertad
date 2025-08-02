import 'package:club_libertad_front/ui/widgets/indicador.dart';
import 'package:club_libertad_front/ui/widgets/posicion_card.dart';
import 'package:club_libertad_front/ui/widgets/ranking_deportista_list.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:club_libertad_front/ui/widgets/torneo_card_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int selectedToggleIndex = 0;

  final List<Deportista> allDeportistas = [
    Deportista(
      posicion: 1,
      nombre: 'Juan Pérez',
      ciudad: 'Trujillo',
      imagen: 'assets/images/escudo.png',
      puntos: 1200,
      torneosAFavor: 4,
      victorias: 12,
      genero: 'masculino',
    ),
    Deportista(
      posicion: 2,
      nombre: 'Carlos Gómez',
      ciudad: 'Lima',
      imagen: 'assets/images/escudo.png',
      puntos: 1150,
      torneosAFavor: 3,
      victorias: 10,
      genero: 'masculino',
    ),
    Deportista(
      posicion: 3,
      nombre: 'Luis Torres',
      ciudad: 'Piura',
      imagen: 'assets/images/escudo.png',
      puntos: 1090,
      torneosAFavor: 2,
      victorias: 9,
      genero: 'masculino',
    ),
    Deportista(
      posicion: 4,
      nombre: 'Ana López',
      ciudad: 'Lima',
      imagen: 'assets/images/escudo.png',
      puntos: 1080,
      torneosAFavor: 3,
      victorias: 11,
      genero: 'femenino',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Deportista> filteredDeportistas;

    switch (selectedToggleIndex) {
      case 1: // Masculino
        filteredDeportistas =
            allDeportistas.where((d) => d.genero == 'masculino').toList();
        break;
      case 2: // Femenino
        filteredDeportistas =
            allDeportistas.where((d) => d.genero == 'femenino').toList();
        break;
      default: // General (todos)
        filteredDeportistas = allDeportistas;
    }

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
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rankings',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Clasificación de jugadores',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TorneoCardList(),
            const SizedBox(height: 15),
            const TuPosicionCard(
              puestoActual: 3,
              puestoAnterior: 5,
              puntaje: 940,
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IndicadorIconoTexto(
                  icono: FaIcon(FontAwesomeIcons.trophy),
                  iconoColor: Colors.amber,
                  cantidad: '5',
                  etiqueta: 'Torneos',
                ),
                IndicadorIconoTexto(
                  icono: FaIcon(FontAwesomeIcons.medal),
                  iconoColor: Colors.green,
                  cantidad: '12',
                  etiqueta: 'Victorias',
                ),
                IndicadorIconoTexto(
                  icono: FaIcon(FontAwesomeIcons.calendar),
                  iconoColor: Colors.blue,
                  cantidad: '28',
                  etiqueta: 'Win Rate',
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ToggleFormSelector(
                options: const ['General', 'Masculino', 'Femenino'],
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
            const SizedBox(height: 15),
            RankingDeportistasList(deportistas: filteredDeportistas),
          ],
        ),
      ),
    );
  }
}
