import 'package:flutter/material.dart';
import '../helpers/subscription_helper.dart';
// import '../screens/subscription_screen.dart'; // Unused?
import 'barthel_screen.dart';
import 'rmi_screen.dart';
import 'scat_screen.dart';
import 'pcss_screen.dart';
import 'abc_screen.dart';
import 'berg_screen.dart';
import 'tinetti_screen.dart';
import 'fga_screen.dart';
import 'tug_screen.dart';
import 'dhi_screen.dart';
import 'mmse_screen.dart';
import 'moca_screen.dart';
import 'ace_iii_screen.dart';
import 'nitrini_screen.dart';
import 'hoehn_yahr_screen.dart';
import 'fss_screen.dart';
import 'mrc_screen.dart';
import 'updrs_screen.dart';
import 'mds_updrs_screen.dart';
import 'tremor_rating_screen.dart';
import 'nmss_screen.dart';
import 'pdq39_screen.dart';
import 'alsfrs_r_screen.dart';
import 'edss_screen.dart';
import 'msfc_screen.dart';
import 'msis29_screen.dart';
import 'myopathy_severity_screen.dart';
import 'cmtns_screen.dart';
import 'cdt_screen.dart';
import 'phq9_screen.dart';
import 'gad7_screen.dart';
import 'gds_screen.dart';
import 'ess_screen.dart';
import 'vas_screen.dart';
import 'midas_screen.dart';
import 'hit6_screen.dart';
import 'lawton_iadl_screen.dart';
import 'bims_screen.dart';
import 'sdmt_screen.dart';
import 'ham_d_screen.dart';
import 'smfq_screen.dart';
import 'hdi_screen.dart';
import 'pcs_screen.dart';
import 'ichd_screen.dart';
import 'sf_mpq_screen.dart';
import 'npi_screen.dart';
import 'adas_cog_screen.dart';
import 'sf12_screen.dart';
import 'whoqol_bref_screen.dart';
import 'psqi_screen.dart';

class AmbulatoryScoresScreen extends StatefulWidget {
  const AmbulatoryScoresScreen({super.key});

  @override
  State<AmbulatoryScoresScreen> createState() => _AmbulatoryScoresScreenState();
}

class _AmbulatoryScoresScreenState extends State<AmbulatoryScoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final List<Map<String, dynamic>> _allScores;

  @override
  void initState() {
    super.initState();
    _allScores = [
      {
        'title': 'Barthel Index',
        'subtitle': 'Índice de Barthel\nAvaliação de atividades de vida diária',
        'icon': Icons.accessibility_new,
        'color': Colors.teal,
        'screen': const BarthelScreen(),
        'scaleName': 'Barthel',
      },
      {
        'title': 'Rivermead Mobility Index',
        'subtitle': 'Índice de Mobilidade de Rivermead\nAvaliação de mobilidade funcional',
        'icon': Icons.directions_walk,
        'color': Colors.blueGrey,
        'screen': const RMIScreen(),
        'scaleName': 'RMI',
      },
      {
        'title': 'SCAT',
        'subtitle': 'Sport Concussion Assessment Tool\nAvaliação de concussão esportiva',
        'icon': Icons.sports_baseball,
        'color': Colors.lightBlue,
        'screen': const SCATScreen(),
        'scaleName': 'SCAT',
      },
      {
        'title': 'PCSS',
        'subtitle': 'Post-Concussion Symptom Scale\nEscala de sintomas pós-concussão',
        'icon': Icons.psychology,
        'color': Colors.tealAccent,
        'screen': const PCSSScreen(),
        'scaleName': 'PCSS',
      },
      {
        'title': 'ABC Scale',
        'subtitle': 'Activities-Specific Balance Confidence\nAvaliação de confiança no equilíbrio',
        'icon': Icons.balance,
        'color': Colors.indigo,
        'screen': const ABCScreen(),
        'scaleName': 'ABC',
      },
      {
        'title': 'Berg Balance Scale',
        'subtitle': 'Escala de Equilíbrio de Berg\nAvaliação de equilíbrio funcional',
        'icon': Icons.straighten,
        'color': Colors.deepPurple,
        'screen': const BergScreen(),
        'scaleName': 'Berg',
      },
      {
        'title': 'Tinetti Balance Assessment',
        'subtitle': 'Avaliação de Equilíbrio Tinetti\nAvaliação de equilíbrio e marcha',
        'icon': Icons.trending_up,
        'color': Colors.brown,
        'screen': const TinettiScreen(),
        'scaleName': 'Tinetti',
      },
      {
        'title': 'Functional Gait Assessment',
        'subtitle': 'Avaliação Funcional da Marcha\nAvaliação de marcha funcional',
        'icon': Icons.directions_run,
        'color': Colors.amber,
        'screen': const FGAScreen(),
        'scaleName': 'FGA',
      },
      {
        'title': 'Timed Up & Go (TUG)',
        'subtitle': 'Teste de Mobilidade e Risco de Queda\nAvaliação de mobilidade',
        'icon': Icons.timer,
        'color': Colors.pink,
        'screen': const TUGScreen(),
        'scaleName': 'TUG',
      },
      {
        'title': 'Dizziness Handicap Inventory',
        'subtitle': 'Inventário de Incapacidade por Tontura\nAvaliação do impacto da tontura',
        'icon': Icons.sentiment_dissatisfied,
        'color': Colors.purple,
        'screen': const DHIScreen(),
        'scaleName': 'DHI',
      },
      {
        'title': 'Mini-Mental State Examination (MMSE)',
        'subtitle': 'Exame do Estado Mental\nAvaliação cognitiva (0-30 pontos)',
        'icon': Icons.psychology,
        'color': Colors.blue,
        'screen': const MMSEScreen(),
        'scaleName': 'MMSE',
      },
      {
        'title': 'Montreal Cognitive Assessment (MoCA)',
        'subtitle': 'Avaliação Cognitiva de Montreal\nAvaliação cognitiva abrangente (0-30 pontos)',
        'icon': Icons.memory,
        'color': Colors.purple,
        'screen': const MoCAScreen(),
        'scaleName': 'MoCA',
      },
      {
        'title': 'ACE-III',
        'subtitle': 'Addenbrooke\'s Cognitive Examination\nAvaliação cognitiva abrangente (0-100 pontos)',
        'icon': Icons.psychology_outlined,
        'color': Colors.teal,
        'screen': const ACEIIIScreen(),
        'scaleName': 'ACE-III',
      },
      {
        'title': 'Bateria Breve Nitrini',
        'subtitle': 'Avaliação Cognitiva Brasileira\nAdaptada para baixa escolaridade',
        'icon': Icons.book,
        'color': Colors.amber,
        'screen': const NitriniScreen(),
        'scaleName': 'Nitrini',
      },
      {
        'title': 'Hoehn and Yahr Scale',
        'subtitle': 'Estágios da Doença de Parkinson\nClassificação de estágios (0-5)',
        'icon': Icons.directions_walk,
        'color': Colors.brown,
        'screen': const HoehnYahrScreen(),
        'scaleName': 'Hoehn Yahr',
      },
      {
        'title': 'UPDRS',
        'subtitle': 'Unified Parkinson\'s Disease Rating Scale\nAvaliação completa da doença de Parkinson',
        'icon': Icons.assessment,
        'color': Colors.purple,
        'screen': const UPDRSScreen(),
        'scaleName': 'UPDRS',
      },
      {
        'title': 'MDS-UPDRS',
        'subtitle': 'Movement Disorder Society-UPDRS\nVersão revisada da UPDRS',
        'icon': Icons.trending_up,
        'color': Colors.deepPurple,
        'screen': const MDSUPDRSScreen(),
        'scaleName': 'MDS-UPDRS',
      },
      {
        'title': 'TESTE DA LEVODOPA',
        'subtitle': 'MDS-UPDRS Parte III\nAvaliação motora para teste de levodopa',
        'icon': Icons.timer,
        'color': Colors.teal,
        'screen': const MDSUPDRSScreen(onlyPart3: true),
        'scaleName': 'TESTE DA LEVODOPA',
      },
      {
        'title': 'Tremor Rating Scale',
        'subtitle': 'Escala de Avaliação de Tremor\nAvaliação de tremor de repouso, postural e cinético',
        'icon': Icons.vibration,
        'color': Colors.brown,
        'screen': const TremorRatingScreen(),
        'scaleName': 'Tremor Rating',
      },
      {
        'title': 'NMSS',
        'subtitle': 'Non-Motor Symptoms Scale\nAvaliação de sintomas não motores (30 itens)',
        'icon': Icons.sentiment_satisfied_alt,
        'color': Colors.lightBlue,
        'screen': const NMSSScreen(),
        'scaleName': 'NMSS',
      },
      {
        'title': 'PDQ-39',
        'subtitle': 'Parkinson\'s Disease Questionnaire\nQuestionário de qualidade de vida (39 itens)',
        'icon': Icons.description,
        'color': Colors.pink,
        'screen': const PDQ39Screen(),
        'scaleName': 'PDQ-39',
      },
      {
        'title': 'ALSFRS-R',
        'subtitle': 'Amyotrophic Lateral Sclerosis Functional Rating Scale\nAvaliação funcional de ELA (12 itens)',
        'icon': Icons.accessibility,
        'color': Colors.red,
        'screen': const ALSFRSRScreen(),
        'scaleName': 'ALSFRS-R',
      },
      {
        'title': 'EDSS',
        'subtitle': 'Expanded Disability Status Scale\nEscala expandida do status de incapacidade (0-10.0)',
        'icon': Icons.accessible,
        'color': Colors.indigo,
        'screen': const EDSSScreen(),
        'scaleName': 'EDSS',
      },
      {
        'title': 'MSFC',
        'subtitle': 'Multiple Sclerosis Functional Composite\nComposto funcional de esclerose múltipla',
        'icon': Icons.functions,
        'color': Colors.cyan,
        'screen': const MSFCScreen(),
        'scaleName': 'MSFC',
      },
      {
        'title': 'MSIS-29',
        'subtitle': 'Multiple Sclerosis Impact Scale\nEscala de impacto da esclerose múltipla (29 itens)',
        'icon': Icons.trending_up,
        'color': Colors.cyan,
        'screen': const MSIS29Screen(),
        'scaleName': 'MSIS-29',
      },
      {
        'title': 'MRC Scale',
        'subtitle': 'Medical Research Council Scale\nAvaliação de força muscular (0-5)',
        'icon': Icons.fitness_center,
        'color': Colors.green,
        'screen': const MRCScreen(),
        'scaleName': 'MRC',
      },
      {
        'title': 'Myopathy Severity Scale',
        'subtitle': 'Escala de Severidade de Miopatia\nAvaliação de miopatia',
        'icon': Icons.warning,
        'color': Colors.red,
        'screen': const MyopathySeverityScreen(),
        'scaleName': 'Myopathy Severity',
      },
      {
        'title': 'CMTNS',
        'subtitle': 'Charcot-Marie-Tooth Neuropathy Score\nEscala de neuropatia de Charcot-Marie-Tooth',
        'icon': Icons.bug_report,
        'color': Colors.deepOrange,
        'screen': const CMTNSScreen(),
        'scaleName': 'CMTNS',
      },
      {
        'title': 'Fatigue Severity Scale (FSS)',
        'subtitle': 'Escala de Severidade de Fadiga\nAvaliação de fadiga (9 itens)',
        'icon': Icons.battery_charging_full,
        'color': Colors.orange,
        'screen': const FSSScreen(),
        'scaleName': 'FSS',
      },
      {
        'title': 'Clock Drawing Test (CDT)',
        'subtitle': 'Teste do Desenho do Relógio\nAvaliação cognitiva visuoespacial',
        'icon': Icons.schedule,
        'color': Colors.blue,
        'screen': const CDTScreen(),
        'scaleName': 'CDT',
      },
      {
        'title': 'PHQ-9',
        'subtitle': 'Patient Health Questionnaire-9\nAvaliação de depressão (9 itens)',
        'icon': Icons.mood_bad,
        'color': Colors.blue,
        'screen': const PHQ9Screen(),
        'scaleName': 'PHQ-9',
      },
      {
        'title': 'GAD-7',
        'subtitle': 'Generalized Anxiety Disorder-7\nAvaliação de ansiedade (7 itens)',
        'icon': Icons.mood_bad,
        'color': Colors.purple,
        'screen': const GAD7Screen(),
        'scaleName': 'GAD-7',
      },
      {
        'title': 'GDS-15',
        'subtitle': 'Geriatric Depression Scale\nAvaliação de depressão em idosos (15 itens)',
        'icon': Icons.people,
        'color': Colors.teal,
        'screen': const GDSScreen(),
        'scaleName': 'GDS',
      },
      {
        'title': 'Epworth Sleepiness Scale',
        'subtitle': 'ESS\nAvaliação de sonolência diurna (8 situações)',
        'icon': Icons.bedtime,
        'color': Colors.indigo,
        'screen': const ESSScreen(),
        'scaleName': 'ESS',
      },
      {
        'title': 'VAS - Dor',
        'subtitle': 'Visual Analog Scale\nAvaliação de intensidade de dor (0-10)',
        'icon': Icons.linear_scale,
        'color': Colors.red,
        'screen': const VASScreen(),
        'scaleName': 'VAS',
      },
      {
        'title': 'MIDAS',
        'subtitle': 'Migraine Disability Assessment\nAvaliação de incapacidade por enxaqueca',
        'icon': Icons.healing,
        'color': Colors.deepPurple,
        'screen': const MIDASScreen(),
        'scaleName': 'MIDAS',
      },
      {
        'title': 'HIT-6',
        'subtitle': 'Headache Impact Test\nAvaliação de impacto da cefaleia (6 itens)',
        'icon': Icons.warning_amber,
        'color': Colors.amber,
        'screen': const HIT6Screen(),
        'scaleName': 'HIT-6',
      },
      {
        'title': 'Lawton IADL Scale',
        'subtitle': 'Instrumental Activities of Daily Living\nAvaliação de atividades instrumentais (8 itens)',
        'icon': Icons.home_work,
        'color': Colors.green,
        'screen': const LawtonIADLScreen(),
        'scaleName': 'Lawton IADL',
      },
      {
        'title': 'BIMS',
        'subtitle': 'Brief Interview for Mental Status\nAvaliação cognitiva breve (15 pontos)',
        'icon': Icons.question_answer,
        'color': Colors.blue,
        'screen': const BIMSScreen(),
        'scaleName': 'BIMS',
      },
      {
        'title': 'SDMT',
        'subtitle': 'Symbol Digit Modalities Test\nTeste de velocidade de processamento (90s)',
        'icon': Icons.speed,
        'color': Colors.cyan,
        'screen': const SDMTScreen(),
        'scaleName': 'SDMT',
      },
      {
        'title': 'HAM-D / HDRS',
        'subtitle': 'Hamilton Depression Rating Scale\nAvaliação clínica de depressão (17 itens)',
        'icon': Icons.psychology,
        'color': Colors.blue,
        'screen': const HAMDScreen(),
        'scaleName': 'HAM-D',
      },
      {
        'title': 'SMFQ',
        'subtitle': 'Short Mood and Feelings Questionnaire\nAvaliação de depressão em crianças/adolescentes',
        'icon': Icons.child_care,
        'color': Colors.pink,
        'screen': const SMFQScreen(),
        'scaleName': 'SMFQ',
      },
      {
        'title': 'HDI',
        'subtitle': 'Headache Disability Inventory\nAvaliação de incapacidade por cefaleia (25 itens)',
        'icon': Icons.report_problem,
        'color': Colors.brown,
        'screen': const HDIScreen(),
        'scaleName': 'HDI',
      },
      {
        'title': 'Pain Catastrophizing Scale',
        'subtitle': 'PCS\nAvaliação de pensamentos catastróficos (13 itens)',
        'icon': Icons.local_fire_department,
        'color': Colors.deepPurple,
        'screen': const PainCatastrophizingScreen(),
        'scaleName': 'PCS',
      },
      {
        'title': 'SF-MPQ',
        'subtitle': 'Short-Form McGill Pain Questionnaire\nAvaliação qualitativa da dor (15 descritores)',
        'icon': Icons.local_hospital,
        'color': Colors.deepOrange,
        'screen': const SFMPQScreen(),
        'scaleName': 'SF-MPQ',
      },
      {
        'title': 'ICHD-3',
        'subtitle': 'International Classification of Headache Disorders\nClassificação de cefaleias (versão simplificada)',
        'icon': Icons.class_,
        'color': Colors.blueGrey,
        'screen': const ICHDScreen(),
        'scaleName': 'ICHD',
      },
      {
        'title': 'ADAS-Cog',
        'subtitle': 'Alzheimer\'s Disease Assessment Scale-Cognitive\nAvaliação cognitiva para Alzheimer (11 tarefas, 0-70)',
        'icon': Icons.psychology,
        'color': Colors.red,
        'screen': const ADASCogScreen(),
        'scaleName': 'ADAS-Cog',
      },
      {
        'title': 'NPI',
        'subtitle': 'Neuropsychiatric Inventory\nAvaliação de sintomas neuropsiquiátricos (12 domínios)',
        'icon': Icons.medical_services,
        'color': Colors.orange,
        'screen': const NPIScreen(),
        'scaleName': 'NPI',
      },
      {
        'title': 'SF-12',
        'subtitle': 'SF-12 Health Survey\nAvaliação de qualidade de vida relacionada à saúde (12 itens)',
        'icon': Icons.favorite,
        'color': Colors.lime,
        'screen': const SF12Screen(),
        'scaleName': 'SF-12',
      },
      {
        'title': 'WHOQOL-BREF',
        'subtitle': 'World Health Organization Quality of Life\nAvaliação de qualidade de vida (26 itens, 4 domínios)',
        'icon': Icons.spa,
        'color': Colors.green,
        'screen': const WHOQOLBREFScreen(),
        'scaleName': 'WHOQOL-BREF',
      },
      {
        'title': 'PSQI',
        'subtitle': 'Pittsburgh Sleep Quality Index\nAvaliação da qualidade do sono (7 componentes)',
        'icon': Icons.nightlight,
        'color': Colors.indigo,
        'screen': const PSQIScreen(),
        'scaleName': 'PSQI',
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
        title: const Text('Scores Ambulatoriais'),
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
                    'Selecione o score ambulatorial:',
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final score = filteredScores[index];
                  final color = score['color'] as Color;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                         BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => SubscriptionHelper.navigateToScale(
                          context: context,
                          scaleName: score['scaleName'] as String,
                          screen: score['screen'] as Widget,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  score['icon'] as IconData,
                                  color: color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      score['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF263238),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      score['subtitle'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ],
                          ),
                        ),
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
