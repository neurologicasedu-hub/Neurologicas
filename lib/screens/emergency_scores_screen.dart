import 'package:flutter/material.dart';
import '../helpers/subscription_helper.dart';
import 'nihss_screen.dart';
import 'glasgow_screen.dart';
import 'mrs_screen.dart';
import 'toast_screen.dart';
import 'abcd_screen.dart';
import 'aspects_screen.dart';
import 'ich_screen.dart';
import 'hunt_hess_screen.dart';
import 'fisher_screen.dart';
import 'marshall_screen.dart';
import 'rotterdam_screen.dart';
import 'rts_screen.dart';
import 'ais_screen.dart';
import 'drs_screen.dart';
import 'neuroicu_screen.dart';
import 'icp_screen.dart';
import 'lundberg_screen.dart';
import 'pvi_screen.dart';
import 'cpp_screen.dart';
import 'apache_screen.dart';
import 'stess_screen.dart';
import 'mstess_screen.dart';
import 'seos_screen.dart';
import 'ess_screen.dart';
import 'icuaw_screen.dart';
import 'neuromuscular_screen.dart';
import 'mgfa_screen.dart';
import 'qmg_screen.dart';
import 'gbs_screen.dart';
import 'cha2ds2_vasc_screen.dart';
import 'has_bled_screen.dart';
import 'rope_screen.dart';

class EmergencyScoresScreen extends StatefulWidget {
  const EmergencyScoresScreen({super.key});

  @override
  State<EmergencyScoresScreen> createState() => _EmergencyScoresScreenState();
}

class _EmergencyScoresScreenState extends State<EmergencyScoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final List<Map<String, dynamic>> _allScores;

  @override
  void initState() {
    super.initState();
    _allScores = [
      {
        'title': 'NIHSS',
        'subtitle': 'National Institutes of Health Stroke Scale\nEscala para avaliação de AVC',
        'icon': Icons.health_and_safety,
        'color': Colors.red,
        'screen': const NIHSSScreen(),
        'scaleName': 'NIHSS', // Special handling if needed
      },
      {
        'title': 'Glasgow Coma Scale',
        'subtitle': 'Escala de Coma de Glasgow\nAvaliação de nível de consciência',
        'icon': Icons.visibility,
        'color': Colors.purple,
        'screen': const GlasgowsScreen(),
        'scaleName': 'Glasgow',
      },
      {
        'title': 'mRS',
        'subtitle': 'Modified Rankin Scale\nAvaliação de incapacidade funcional',
        'icon': Icons.assignment,
        'color': Colors.deepPurple,
        'screen': const MRSScreen(),
        'scaleName': 'mRS',
      },
      {
        'title': 'TOAST',
        'subtitle': 'Trial of Org 10172 in Acute Stroke Treatment\nClassificação etiológica de AVC',
        'icon': Icons.local_hospital,
        'color': Colors.orange,
        'screen': const ToastScreen(),
        'scaleName': 'TOAST',
      },
      {
        'title': 'ABCD2 / ABCD3-I',
        'subtitle': 'Escala de risco para AIT\nPredição de risco de acidente vascular',
        'icon': Icons.calculate,
        'color': Colors.cyan,
        'screen': const ABCDScreen(),
        'scaleName': 'ABCD',
      },
      {
        'title': 'ASPECTS',
        'subtitle': 'Alberta Stroke Program Early CT Score\nAvaliação de TC em AVC',
        'icon': Icons.medical_information,
        'color': Colors.indigo,
        'screen': const AspectsScreen(),
        'scaleName': 'ASPECTS',
      },
      {
        'title': 'ICH Score',
        'subtitle': 'Intracerebral Hemorrhage Score\nEscala de risco para hemorragia',
        'icon': Icons.bloodtype,
        'color': Colors.deepPurpleAccent,
        'screen': const ICHScreen(),
        'scaleName': 'ICH',
      },
      {
        'title': 'Hunt and Hess',
        'subtitle': 'Escala de Classificação\nHemorragia Subaracnóidea',
        'icon': Icons.emergency,
        'color': Colors.purple,
        'screen': const HuntHessScreen(),
        'scaleName': 'Hunt and Hess',
      },
      {
        'title': 'Fisher Scale',
        'subtitle': 'Escala de Classificação em TC\nHemorragia Subaracnóidea',
        'icon': Icons.visibility_off,
        'color': Colors.amber,
        'screen': const FisherScreen(),
        'scaleName': 'Fisher',
      },
      {
        'title': 'Marshall Classification',
        'subtitle': 'Classificação baseada em TC\nTrauma cranioencefálico',
        'icon': Icons.scanner,
        'color': Colors.brown,
        'screen': const MarshallScreen(),
        'scaleName': 'Marshall',
      },
      {
        'title': 'Rotterdam CT Score',
        'subtitle': 'Score de TC para HSA\nPrognóstico de mortalidade',
        'icon': Icons.assessment,
        'color': Colors.indigoAccent,
        'screen': const RotterdamScreen(),
        'scaleName': 'Rotterdam',
      },
      {
        'title': 'Revised Trauma Score',
        'subtitle': 'RTS - Escala de trauma revisada\nAvaliação de gravidade',
        'icon': Icons.local_hospital,
        'color': Colors.orange,
        'screen': const RTSScreen(),
        'scaleName': 'RTS',
      },
      {
        'title': 'Abbreviated Injury Scale',
        'subtitle': 'AIS - Escala abreviada de lesão\nSeveridade por região',
        'icon': Icons.warning,
        'color': Colors.redAccent,
        'screen': const AISScreen(),
        'scaleName': 'AIS',
      },
      {
        'title': 'Disability Rating Scale',
        'subtitle': 'DRS - Escala de deficiência\nAvaliação funcional',
        'icon': Icons.accessible,
        'color': Colors.pink,
        'screen': const DRSScreen(),
        'scaleName': 'DRS',
      },
      {
        'title': 'Neurointensivismo / UTI',
        'subtitle': 'Monitorização e condutas\nCuidados intensivos neurológicos',
        'icon': Icons.local_hospital,
        'color': Colors.blue,
        'screen': const NeuroICUScreen(),
        'scaleName': 'NeuroICU',
      },
      {
        'title': 'ICP Monitoring',
        'subtitle': 'Monitorização de Pressão Intracraniana\nAvaliação de ICP e PPC',
        'icon': Icons.speed,
        'color': Colors.deepOrange,
        'screen': const ICPScreen(),
        'scaleName': 'ICP',
      },
      {
        'title': 'Lundberg Waves',
        'subtitle': 'Ondas A, B e C de ICP\nPadrões de pressão intracraniana',
        'icon': Icons.waves,
        'color': Colors.teal,
        'screen': const LundbergScreen(),
        'scaleName': 'Lundberg',
      },
      {
        'title': 'Pressure-Volume Index',
        'subtitle': 'PVI - Complacência intracraniana\nAvaliação de reserva de espaço',
        'icon': Icons.biotech,
        'color': Colors.blueGrey,
        'screen': const PVIScreen(),
        'scaleName': 'PVI',
      },
      {
        'title': 'Cerebral Perfusion Pressure',
        'subtitle': 'CPP - Pressão de perfusão cerebral\nAvaliação de fluxo sanguíneo',
        'icon': Icons.water_drop,
        'color': Colors.cyan,
        'screen': const CPPScreen(),
        'scaleName': 'CPP',
      },
      {
        'title': 'APACHE II',
        'subtitle': 'Acute Physiology and Chronic Health Evaluation\nAvaliação de gravidade em UTI',
        'icon': Icons.assessment,
        'color': Colors.grey,
        'screen': const ApacheScreen(),
        'scaleName': 'APACHE II',
      },
      {
        'title': 'STESS',
        'subtitle': 'Status Epilepticus Severity Score\nPrognóstico de status epiléptico',
        'icon': Icons.flash_on,
        'color': Colors.deepPurple,
        'screen': const STESSScreen(),
        'scaleName': 'STESS',
      },
      {
        'title': 'Modified STESS',
        'subtitle': 'mSTESS - Versão modificada\nScore de severidade de SE',
        'icon': Icons.bolt,
        'color': Colors.purpleAccent,
        'screen': const MSTESSScreen(),
        'scaleName': 'mSTESS',
      },
      {
        'title': 'SEOS',
        'subtitle': 'Status Epilepticus Outcome Score\nPrognóstico funcional',
        'icon': Icons.trending_up,
        'color': Colors.indigo,
        'screen': const SEOSScreen(),
        'scaleName': 'SEOS',
      },
      {
        'title': 'Encephalopathy Severity Score',
        'subtitle': 'ESS - Escala de encefalopatia\nAvaliação de disfunção cerebral',
        'icon': Icons.memory,
        'color': Colors.amber,
        'screen': const ESSScreen(),
        'scaleName': 'ESS Emergency',
      },
      {
        'title': 'ICUAW Scale',
        'subtitle': 'Intensive Care Unit Acquired Weakness\nFraqueza adquirida em UTI',
        'icon': Icons.fitness_center,
        'color': Colors.grey,
        'screen': const ICUAWScreen(),
        'scaleName': 'ICUAW',
      },
      {
        'title': 'Doenças Neuromusculares / Crise',
        'subtitle': 'Avaliação de crise aguda\nDoenças neuromusculares graves',
        'icon': Icons.warning,
        'color': Colors.red,
        'screen': const NeuromuscularScreen(),
        'scaleName': 'Neuromuscular',
      },
      {
        'title': 'MGFA Classification',
        'subtitle': 'Myasthenia Gravis Foundation\nClassificação clínica de MG',
        'icon': Icons.medication,
        'color': Colors.blue,
        'screen': const MGFAScreen(),
        'scaleName': 'MGFA',
      },
      {
        'title': 'QMG Score',
        'subtitle': 'Quantitative Myasthenia Gravis\nScore quantitativo de MG',
        'icon': Icons.line_weight,
        'color': Colors.lightBlue,
        'screen': const QMGScreen(),
        'scaleName': 'QMG',
      },
      {
        'title': 'GBS Disability Score',
        'subtitle': 'Guillain-Barré Syndrome\nEscala de deficiência',
        'icon': Icons.accessibility_new,
        'color': Colors.green,
        'screen': const GBSScreen(),
        'scaleName': 'GBS',
      },
      {
        'title': 'CHA₂DS₂-VASc Score',
        'subtitle': 'Risco embólico em FA\nAvaliação de risco cardiovascular',
        'icon': Icons.favorite,
        'color': Colors.blue,
        'screen': const CHA2DS2VAScScreen(),
        'scaleName': 'CHA2DS2-VASc',
      },
      {
        'title': 'HAS-BLED Score',
        'subtitle': 'Risco de sangramento\nAvaliação de risco hemorrágico',
        'icon': Icons.bloodtype,
        'color': Colors.red,
        'screen': const HASBLEDScreen(),
        'scaleName': 'HAS-BLED',
      },
      {
        'title': 'RoPE Score',
        'subtitle': 'Risk of Paradoxical Embolism\nRisco de embolia paradoxal em FOP',
        'icon': Icons.favorite,
        'color': Colors.redAccent,
        'screen': const RopeScreen(),
        'scaleName': 'RoPE',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredScores = _allScores.where((score) {
      final title = score['title'].toString().toLowerCase();
      final subtitle = score['subtitle'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || subtitle.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scores de Emergência'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar score...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Selecione o score de emergência:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final score = filteredScores[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(
                          score['icon'] as IconData,
                          color: score['color'] as Color,
                          size: 36,
                        ),
                        title: Text(
                          score['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          score['subtitle'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          if (score['title'] == 'NIHSS') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => score['screen'] as Widget,
                              ),
                            );
                          } else {
                            SubscriptionHelper.navigateToScale(
                              context: context,
                              scaleName: score['scaleName'] as String,
                              screen: score['screen'] as Widget,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
                childCount: filteredScores.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
