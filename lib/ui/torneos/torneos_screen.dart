import 'package:club_libertad_front/data/services/torneo_repository_service_imp.dart';
import 'package:club_libertad_front/domain/entities/torneos/request/torneo_request.dart';
import 'package:club_libertad_front/domain/entities/torneos/response/torneo_response.dart';
import 'package:club_libertad_front/domain/services/torneo_service.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:club_libertad_front/ui/widgets/torneo_data.dart';
import 'package:flutter/material.dart';
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
  final List<String> estados = ['Abierto', 'En Curso', 'Finalizado'];

  final TorneoService _torneoService = TorneoRepositoryServiceImp();
  List<TournamentResponse> torneos = [];
  bool isLoading = false;

  final ciudades = ['Trujillo', 'Lima', 'Piura'];
  final niveles = ['A', 'B', 'C'];
  final superficies = ['Clay', 'Grass', 'Hard'];

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = TournamentRequest(
        status: estados[selectedEstadoIndex],
        level: selectedNivel,
        surface: selectedSuperficie,
        location: selectedCiudad,
        limit: 20,
        offset: 0,
      );

      final result = await _torneoService.findTorneo(request);

      if (result.statusCode == 200 && result.data != null) {
        setState(() {
          torneos = result.data!;
        });
      }
    } catch (e) {
      print('Error cargando torneos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _aplicarFiltros() {
    Navigator.pop(context);
    _cargarTorneos();
  }

  TorneoData _convertirTournamentResponseATorneoData(
      TournamentResponse tournament) {
    final DateTime startDate = DateTime.parse(tournament.startDate);
    final String fechaFormateada =
        "${startDate.day} ${_obtenerMesAbreviado(startDate.month)} ${startDate.year}";

    final double porcentaje = tournament.totalSlots > 0
        ? (tournament.currentRegistrations / tournament.totalSlots) * 100
        : 0;

    return TorneoData(
      titulo: tournament.name,
      categoria: tournament.level ?? tournament.type,
      nombre: tournament.location.split(' - ').first,
      ciudad: tournament.location.split(' - ').last,
      fecha: fechaFormateada,
      monto: tournament.registrationFee != null
          ? '${tournament.currency ?? 'PEN'} ${tournament.registrationFee}'
          : 'Gratis',
      inscritos: tournament.currentRegistrations,
      totalCupos: tournament.totalSlots,
      puntos: tournament.points ?? 0,
      superficie: tournament.surface,
      porcentaje: porcentaje,
      estado: tournament.status,
    );
  }

  String _obtenerMesAbreviado(int mes) {
    const meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return meses[mes];
  }

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
                  onPressed: _aplicarFiltros,
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
      body: Column(
        children: [
          // Header fijo con título, búsqueda y filtros
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y descripción
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Torneos',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Encuentra y participa en torneos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Barra de búsqueda y filtro
                Row(
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
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
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
                const SizedBox(height: 16),
                // Selector de estado
                ToggleFormSelector(
                  options: estados,
                  selectedIndex: selectedEstadoIndex,
                  onChanged: (index) {
                    setState(() {
                      selectedEstadoIndex = index;
                    });
                    _cargarTorneos();
                  },
                  selectedColor: Colors.white,
                  selectedTextColor: Colors.black,
                ),
              ],
            ),
          ),
          // Lista scrolleable de torneos
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: torneos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TorneoCard(
                          _convertirTournamentResponseATorneoData(
                              torneos[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
