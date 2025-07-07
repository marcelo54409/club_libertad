import 'package:club_libertad_front/ui/widgets/jugador_card.dart';
import 'package:club_libertad_front/ui/widgets/match_status.dart';
import 'package:club_libertad_front/ui/widgets/ranking_deportista_list.dart';
import 'package:club_libertad_front/ui/widgets/resumen_box.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TorneoData {
  final String titulo;
  final String categoria;
  final String nombre;
  final String ciudad;
  final String fecha;
  final String monto;
  final int inscritos;
  final int totalCupos;
  final int puntos;
  final double porcentaje;
  final String superficie;
  final String estado;

  TorneoData({
    required this.titulo,
    required this.categoria,
    required this.nombre,
    required this.ciudad,
    required this.fecha,
    required this.monto,
    required this.inscritos,
    required this.totalCupos,
    required this.puntos,
    required this.porcentaje,
    required this.superficie,
    required this.estado,
  });
}

class TorneoCard extends StatefulWidget {
  final TorneoData data;
  const TorneoCard(this.data);

  @override
  State<TorneoCard> createState() => _TorneoCardState();
}

class _TorneoCardState extends State<TorneoCard> {
  String? selectedCiudad;
  String? selectedNivel;

  final List<String> ciudades = ['Trujillo', 'Lima', 'Piura'];
  final List<String> niveles = ['A', 'B', 'C'];

  final List<String> fases = [
    'Inscripciones',
    'Primera ronda',
    'Octavos',
    'Cuartos',
    'Semifinales',
    'Final',
  ];
  final int faseActual = 2;
  final List<Deportista> deportistas = [
    Deportista(
      posicion: 1,
      nombre: 'Juan Pérez',
      ciudad: 'Trujillo',
      imagen: 'assets/images/escudo.png',
      puntos: 80,
      torneosAFavor: 3,
      victorias: 12,
      genero: 'M',
    ),
    Deportista(
      posicion: 2,
      nombre: 'Luis García',
      ciudad: 'Lima',
      imagen: 'assets/images/escudo.png',
      puntos: 65,
      torneosAFavor: 2,
      victorias: 9,
      genero: 'M',
    ),
    Deportista(
      posicion: 3,
      nombre: 'Carlos Ruiz',
      ciudad: 'Arequipa',
      imagen: 'assets/images/escudo.png',
      puntos: 72,
      torneosAFavor: 1,
      victorias: 10,
      genero: 'M',
    ),
    Deportista(
      posicion: 4,
      nombre: 'José Torres',
      ciudad: 'Piura',
      imagen: 'assets/images/escudo.png',
      puntos: 58,
      torneosAFavor: 1,
      victorias: 6,
      genero: 'M',
    ),
    Deportista(
      posicion: 5,
      nombre: 'Ana Fernández',
      ciudad: 'Chiclayo',
      imagen: 'assets/images/escudo.png',
      puntos: 90,
      torneosAFavor: 4,
      victorias: 14,
      genero: 'F',
    ),
    Deportista(
      posicion: 6,
      nombre: 'María Rojas',
      ciudad: 'Cusco',
      imagen: 'assets/images/escudo.png',
      puntos: 50,
      torneosAFavor: 1,
      victorias: 5,
      genero: 'F',
    ),
  ];

  void _showInscribirse() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        title: const Text('Inscripción al torneo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Copa',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Club Deportivo'),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categoría',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedCiudad,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
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
                  'Contacto de Emergencia',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedNivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); 
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Confirmar inscripción',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetallesTorneo(
    BuildContext context,
    String titulo,
    String lugar,
    String ciudad,
  ) {
    int selectedTabIndex = 0;
    final tabs = ['Resumen', 'Cuadro', 'Jugadores'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor:
                  Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 600, maxWidth: 400),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Detalles del torneo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      
                      Text(
                        'Copa "$titulo"\n$lugar - $ciudad',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),
                      const Divider(color: Colors.grey, thickness: 0.7),

                      
                      ToggleFormSelector(
                        options: tabs,
                        selectedIndex: selectedTabIndex,
                        onChanged: (index) =>
                            setState(() => selectedTabIndex = index),
                        selectedColor: Colors.white,
                        selectedTextColor: Colors.black,
                      ),

                      const SizedBox(height: 16),

                      
                      Expanded(
                        child: SingleChildScrollView(
                          child: Builder(
                            builder: (_) {
                              if (selectedTabIndex == 0) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ResumenBox(
                                          icon: Icons.calendar_today,
                                          label: 'Fecha',
                                          value: '12 Jul 2025',
                                        ),
                                        const SizedBox(width: 8),
                                        ResumenBox(
                                          icon: Icons.emoji_events,
                                          label: 'Premio',
                                          value: 'S/ 500',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        ResumenBox(
                                          icon: Icons.people,
                                          label: 'Inscritos',
                                          value: '14/32',
                                        ),
                                        const SizedBox(width: 8),
                                        ResumenBox(
                                          icon: Icons.bar_chart,
                                          label: 'Nivel',
                                          value: 'Intermedio',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                      
                                    const Text(
                                      'Progreso del torneo',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                      
                                    Stack(
                                      children: [
                                        Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.44, 
                                          child: Container(
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          top: 2,
                                          child: Text(
                                            '44%',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Inscripciones abiertas',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Fases del torneo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...List.generate(fases.length, (index) {
                                      final esActual = index == faseActual;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: esActual
                                                    ? Colors.blue
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: esActual
                                                      ? Colors.white
                                                      : Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                fases[index],
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ),
                                            if (esActual)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: const Text(
                                                  'Actual',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        ResumenBox(
                                          icon: Icons.people,
                                          label: 'Inscritos',
                                          value: '14/32',
                                        ),
                                        const SizedBox(width: 8),
                                        ResumenBox(
                                          icon: Icons.bar_chart,
                                          label: 'Nivel',
                                          value: 'Intermedio',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        ResumenBox(
                                          icon: Icons.people,
                                          label: 'Inscritos',
                                          value: '14/32',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Información',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        const Text('Superficie:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text('Arcilla'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text('Categoría:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text('Abierto'),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Descripción',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Torneo abierto al público donde se disputarán emocionantes encuentros entre jugadores de distintas regiones.',
                                      style: TextStyle(fontSize: 13),
                                    ),

                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Contacto',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text('Organizador:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                            child: Text(
                                                'Club Deportivo Trujillo')),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text('Teléfono:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                            child: Text('+51 987 654 321')),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text('Email:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                            child: Text(
                                                'contacto@clubtrujillo.com')),
                                      ],
                                    ),
                                  ],
                                );
                              } else if (selectedTabIndex == 1) {
                                final faseActualNombre = fases[faseActual];

                                return Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        faseActualNombre,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Estado actual del torneo',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),

                                  
                                    MatchCard(
                                      fase: 'Octavos',
                                      status: MatchStatus.finalizado,
                                      jugadorA: 'Juan Pérez',
                                      jugadorB: 'Luis Torres',
                                      marcador: '6-3 6-4',
                                      ganador: 'Juan Pérez',
                                    ),
                                    MatchCard(
                                      fase: 'Octavos',
                                      status: MatchStatus.enVivo,
                                      jugadorA: 'Carlos Gómez',
                                      jugadorB: 'Andrés Ruiz',
                                      marcador: '4-6 6-4 3-2',
                                      ganador:
                                          'Carlos Gómez',
                                    ),
                                    MatchCard(
                                      fase: 'Octavos',
                                      status: MatchStatus.programado,
                                      jugadorA: 'Mario Díaz',
                                      jugadorB: 'Alberto Gil',
                                      marcador: '',
                                      ganador: '', 
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Lista de participantes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${deportistas.length} jugadores inscritos',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ListView.builder(
                                      itemCount: deportistas.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final deportista = deportistas[index];
                                        return JugadorCard(
                                          posicion: deportista.posicion,
                                          nombre: deportista.nombre,
                                          ciudad: deportista.ciudad,
                                          imagen: deportista.imagen,
                                          ranking: deportista
                                              .puntos,
                                          estaActivo:
                                              true, 
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Colors.black12),
                                ),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Cerrar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showInscribirse();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Inscribirse',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color _getEstadoColor(String estado) {
      switch (estado.toLowerCase()) {
        case 'abierto':
          return Colors.green;
        case 'en curso':
          return Colors.blue;
        case 'finalizado':
          return Colors.grey;
        default:
          return Colors.black26;
      }
    }

    return Stack(
      children: [
    
        Positioned(
          left: 13,
          top: 12,
          bottom: 11,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: _getEstadoColor(widget.data.estado),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Container(
          margin:
              const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data.titulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 49, 133),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.data.categoria,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text('${widget.data.nombre} - ${widget.data.ciudad}'),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(widget.data.fecha),
                  const SizedBox(width: 16),
                  const Icon(FontAwesomeIcons.dollarSign,
                      size: 14, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(widget.data.monto),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.deepPurple),
                  const SizedBox(width: 6),
                  Text(
                      '${widget.data.inscritos}/${widget.data.totalCupos} inscritos'),
                  const SizedBox(width: 16),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text('${widget.data.puntos} pts'),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: widget.data.porcentaje / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text(
                      '${widget.data.porcentaje.toStringAsFixed(0)}% inscritos'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Superficie: ${widget.data.superficie}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Flexible(
                    child: OutlinedButton(
                      onPressed: () {
                        _mostrarDetallesTorneo(context, 'Verano 2025',
                            'Club La Arboleda', 'Trujillo');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: const Text('Ver detalle',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        _showInscribirse();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 35, 19),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: const Text('Inscribirse',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
