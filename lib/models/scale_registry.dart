import 'package:flutter/material.dart';
import '../screens/nihss_screen.dart';
import '../screens/glasgow_screen.dart';
import '../screens/mrs_screen.dart';
import '../screens/toast_screen.dart';
import '../screens/abcd_screen.dart';
import '../screens/aspects_screen.dart';
import '../screens/ich_screen.dart';
import '../screens/hunt_hess_screen.dart';
import '../screens/fisher_screen.dart';
import '../screens/marshall_screen.dart';
import '../screens/rotterdam_screen.dart';
import '../screens/rts_screen.dart';
import '../screens/ais_screen.dart';
import '../screens/drs_screen.dart';
import '../screens/neuroicu_screen.dart';
import '../screens/icp_screen.dart';
import '../screens/lundberg_screen.dart';
import '../screens/pvi_screen.dart';
import '../screens/cpp_screen.dart';
import '../screens/apache_screen.dart';
import '../screens/stess_screen.dart';
import '../screens/mstess_screen.dart';
import '../screens/seos_screen.dart';
import '../screens/ess_screen.dart';
import '../screens/icuaw_screen.dart';
import '../screens/neuromuscular_screen.dart';
import '../screens/mgfa_screen.dart';
import '../screens/qmg_screen.dart';
import '../screens/gbs_screen.dart';
import '../screens/cha2ds2_vasc_screen.dart';
import '../screens/has_bled_screen.dart';
import '../screens/rope_screen.dart';
import '../screens/barthel_screen.dart';
import '../screens/rmi_screen.dart';
import '../screens/scat_screen.dart';
import '../screens/pcss_screen.dart';
import '../screens/abc_screen.dart';
import '../screens/berg_screen.dart';
import '../screens/tinetti_screen.dart';
import '../screens/fga_screen.dart';
import '../screens/tug_screen.dart';
import '../screens/dhi_screen.dart';
import '../screens/mmse_screen.dart';
import '../screens/moca_screen.dart';
import '../screens/ace_iii_screen.dart';
import '../screens/nitrini_screen.dart';
import '../screens/hoehn_yahr_screen.dart';
import '../screens/fss_screen.dart';
import '../screens/mrc_screen.dart';
import '../screens/updrs_screen.dart';
import '../screens/mds_updrs_screen.dart';
import '../screens/tremor_rating_screen.dart';
import '../screens/nmss_screen.dart';
import '../screens/pdq39_screen.dart';
import '../screens/alsfrs_r_screen.dart';
import '../screens/edss_screen.dart';
import '../screens/msfc_screen.dart';
import '../screens/msis29_screen.dart';
import '../screens/myopathy_severity_screen.dart';
import '../screens/cmtns_screen.dart';
import '../screens/cdt_screen.dart';
import '../screens/phq9_screen.dart';
import '../screens/gad7_screen.dart';
import '../screens/gds_screen.dart';
import '../screens/vas_screen.dart';
import '../screens/midas_screen.dart';
import '../screens/hit6_screen.dart';
import '../screens/lawton_iadl_screen.dart';
import '../screens/bims_screen.dart';
import '../screens/sdmt_screen.dart';
import '../screens/ham_d_screen.dart';
import '../screens/smfq_screen.dart';
import '../screens/hdi_screen.dart';
import '../screens/pcs_screen.dart';
import '../screens/ichd_screen.dart';
import '../screens/sf_mpq_screen.dart';
import '../screens/npi_screen.dart';
import '../screens/adas_cog_screen.dart';
import '../screens/sf12_screen.dart';
import '../screens/whoqol_bref_screen.dart';
import '../screens/psqi_screen.dart';

class ScaleRegistry {
  static final List<Map<String, dynamic>> allScales = [
    // --- Emergency Scores ---
    {
      'title': 'NIHSS',
      'subtitle': 'National Institutes of Health Stroke Scale\nEscala para avaliação de AVC',
      'icon': Icons.health_and_safety,
      'color': Colors.red,
      'screen': const NIHSSScreen(),
      'scaleName': 'NIHSS',
      'category': 'Emergencial',
    },
    {
      'title': 'Glasgow Coma Scale',
      'subtitle': 'Escala de Coma de Glasgow\nAvaliação de nível de consciência',
      'icon': Icons.visibility,
      'color': Colors.purple,
      'screen': const GlasgowsScreen(),
      'scaleName': 'Glasgow',
      'category': 'Emergencial',
    },
    {
      'title': 'mRS',
      'subtitle': 'Modified Rankin Scale\nAvaliação de incapacidade funcional',
      'icon': Icons.assignment,
      'color': Colors.deepPurple,
      'screen': const MRSScreen(),
      'scaleName': 'mRS',
      'category': 'Emergencial',
    },
    {
      'title': 'TOAST',
      'subtitle': 'Trial of Org 10172 in Acute Stroke Treatment\nClassificação etiológica de AVC',
      'icon': Icons.local_hospital,
      'color': Colors.orange,
      'screen': const ToastScreen(),
      'scaleName': 'TOAST',
      'category': 'Emergencial',
    },
    {
      'title': 'ABCD2 / ABCD3-I',
      'subtitle': 'Escala de risco para AIT\nPredição de risco de acidente vascular',
      'icon': Icons.calculate,
      'color': Colors.cyan,
      'screen': const ABCDScreen(),
      'scaleName': 'ABCD',
      'category': 'Emergencial',
    },
    {
      'title': 'ASPECTS',
      'subtitle': 'Alberta Stroke Program Early CT Score\nAvaliação de TC em AVC',
      'icon': Icons.medical_information,
      'color': Colors.indigo,
      'screen': const AspectsScreen(),
      'scaleName': 'ASPECTS',
      'category': 'Emergencial',
    },
    {
      'title': 'ICH Score',
      'subtitle': 'Intracerebral Hemorrhage Score\nEscala de risco para hemorragia',
      'icon': Icons.bloodtype,
      'color': Colors.deepPurpleAccent,
      'screen': const ICHScreen(),
      'scaleName': 'ICH',
      'category': 'Emergencial',
    },
    {
      'title': 'Hunt and Hess',
      'subtitle': 'Escala de Classificação\nHemorragia Subaracnóidea',
      'icon': Icons.emergency,
      'color': Colors.purple,
      'screen': const HuntHessScreen(),
      'scaleName': 'Hunt and Hess',
      'category': 'Emergencial',
    },
    {
      'title': 'Fisher Scale',
      'subtitle': 'Escala de Classificação em TC\nHemorragia Subaracnóidea',
      'icon': Icons.visibility_off,
      'color': Colors.amber,
      'screen': const FisherScreen(),
      'scaleName': 'Fisher',
      'category': 'Emergencial',
    },
    {
      'title': 'Marshall Classification',
      'subtitle': 'Classificação baseada em TC\nTrauma cranioencefálico',
      'icon': Icons.scanner,
      'color': Colors.brown,
      'screen': const MarshallScreen(),
      'scaleName': 'Marshall',
      'category': 'Emergencial',
    },
    {
      'title': 'Rotterdam CT Score',
      'subtitle': 'Score de TC para HSA\nPrognóstico de mortalidade',
      'icon': Icons.assessment,
      'color': Colors.indigoAccent,
      'screen': const RotterdamScreen(),
      'scaleName': 'Rotterdam',
      'category': 'Emergencial',
    },
    {
      'title': 'Revised Trauma Score',
      'subtitle': 'RTS - Escala de trauma revisada\nAvaliação de gravidade',
      'icon': Icons.local_hospital,
      'color': Colors.orange,
      'screen': const RTSScreen(),
      'scaleName': 'RTS',
      'category': 'Emergencial',
    },
    {
      'title': 'Abbreviated Injury Scale',
      'subtitle': 'AIS - Escala abreviada de lesão\nSeveridade por região',
      'icon': Icons.warning,
      'color': Colors.redAccent,
      'screen': const AISScreen(),
      'scaleName': 'AIS',
      'category': 'Emergencial',
    },
    {
      'title': 'Disability Rating Scale',
      'subtitle': 'DRS - Escala de deficiência\nAvaliação funcional',
      'icon': Icons.accessible,
      'color': Colors.pink,
      'screen': const DRSScreen(),
      'scaleName': 'DRS',
      'category': 'Emergencial',
    },
    {
      'title': 'Neurointensivismo / UTI',
      'subtitle': 'Monitorização e condutas\nCuidados intensivos neurológicos',
      'icon': Icons.local_hospital,
      'color': Colors.blue,
      'screen': const NeuroICUScreen(),
      'scaleName': 'NeuroICU',
      'category': 'Emergencial',
    },
    {
      'title': 'ICP Monitoring',
      'subtitle': 'Monitorização de Pressão Intracraniana\nAvaliação de ICP e PPC',
      'icon': Icons.speed,
      'color': Colors.deepOrange,
      'screen': const ICPScreen(),
      'scaleName': 'ICP',
      'category': 'Emergencial',
    },
    {
      'title': 'Lundberg Waves',
      'subtitle': 'Ondas A, B e C de ICP\nPadrões de pressão intracraniana',
      'icon': Icons.waves,
      'color': Colors.teal,
      'screen': const LundbergScreen(),
      'scaleName': 'Lundberg',
      'category': 'Emergencial',
    },
    {
      'title': 'Pressure-Volume Index',
      'subtitle': 'PVI - Complacência intracraniana\nAvaliação de reserva de espaço',
      'icon': Icons.biotech,
      'color': Colors.blueGrey,
      'screen': const PVIScreen(),
      'scaleName': 'PVI',
      'category': 'Emergencial',
    },
    {
      'title': 'Cerebral Perfusion Pressure',
      'subtitle': 'CPP - Pressão de perfusão cerebral\nAvaliação de fluxo sanguíneo',
      'icon': Icons.water_drop,
      'color': Colors.cyan,
      'screen': const CPPScreen(),
      'scaleName': 'CPP',
      'category': 'Emergencial',
    },
    {
      'title': 'APACHE II',
      'subtitle': 'Acute Physiology and Chronic Health Evaluation\nAvaliação de gravidade em UTI',
      'icon': Icons.assessment,
      'color': Colors.grey,
      'screen': const ApacheScreen(),
      'scaleName': 'APACHE II',
      'category': 'Emergencial',
    },
    {
      'title': 'STESS',
      'subtitle': 'Status Epilepticus Severity Score\nPrognóstico de status epiléptico',
      'icon': Icons.flash_on,
      'color': Colors.deepPurple,
      'screen': const STESSScreen(),
      'scaleName': 'STESS',
      'category': 'Emergencial',
    },
    {
      'title': 'Modified STESS',
      'subtitle': 'mSTESS - Versão modificada\nScore de severidade de SE',
      'icon': Icons.bolt,
      'color': Colors.purpleAccent,
      'screen': const MSTESSScreen(),
      'scaleName': 'mSTESS',
      'category': 'Emergencial',
    },
    {
      'title': 'SEOS',
      'subtitle': 'Status Epilepticus Outcome Score\nPrognóstico funcional',
      'icon': Icons.trending_up,
      'color': Colors.indigo,
      'screen': const SEOSScreen(),
      'scaleName': 'SEOS',
      'category': 'Emergencial',
    },
    {
      'title': 'Encephalopathy Severity Score',
      'subtitle': 'ESS - Escala de encefalopatia\nAvaliação de disfunção cerebral',
      'icon': Icons.memory,
      'color': Colors.amber,
      'screen': const ESSScreen(),
      'scaleName': 'ESS Emergency',
      'category': 'Emergencial',
    },
    {
      'title': 'ICUAW Scale',
      'subtitle': 'Intensive Care Unit Acquired Weakness\nFraqueza adquirida em UTI',
      'icon': Icons.fitness_center,
      'color': Colors.grey,
      'screen': const ICUAWScreen(),
      'scaleName': 'ICUAW',
      'category': 'Emergencial',
    },
    {
      'title': 'Doenças Neuromusculares / Crise',
      'subtitle': 'Avaliação de crise aguda\nDoenças neuromusculares graves',
      'icon': Icons.warning,
      'color': Colors.red,
      'screen': const NeuromuscularScreen(),
      'scaleName': 'Neuromuscular',
      'category': 'Emergencial',
    },
    {
      'title': 'MGFA Classification',
      'subtitle': 'Myasthenia Gravis Foundation\nClassificação clínica de MG',
      'icon': Icons.medication,
      'color': Colors.blue,
      'screen': const MGFAScreen(),
      'scaleName': 'MGFA',
      'category': 'Emergencial',
    },
    {
      'title': 'QMG Score',
      'subtitle': 'Quantitative Myasthenia Gravis\nScore quantitativo de MG',
      'icon': Icons.line_weight,
      'color': Colors.lightBlue,
      'screen': const QMGScreen(),
      'scaleName': 'QMG',
      'category': 'Emergencial',
    },
    {
      'title': 'GBS Disability Score',
      'subtitle': 'Guillain-Barré Syndrome\nEscala de deficiência',
      'icon': Icons.accessibility_new,
      'color': Colors.green,
      'screen': const GBSScreen(),
      'scaleName': 'GBS',
      'category': 'Emergencial',
    },
    {
      'title': 'CHA₂DS₂-VASc Score',
      'subtitle': 'Risco embólico em FA\nAvaliação de risco cardiovascular',
      'icon': Icons.favorite,
      'color': Colors.blue,
      'screen': const CHA2DS2VAScScreen(),
      'scaleName': 'CHA2DS2-VASc',
      'category': 'Emergencial',
    },
    {
      'title': 'HAS-BLED Score',
      'subtitle': 'Risco de sangramento\nAvaliação de risco hemorrágico',
      'icon': Icons.bloodtype,
      'color': Colors.red,
      'screen': const HASBLEDScreen(),
      'scaleName': 'HAS-BLED',
      'category': 'Emergencial',
    },
    {
      'title': 'RoPE Score',
      'subtitle': 'Risk of Paradoxical Embolism\nRisco de embolia paradoxal em FOP',
      'icon': Icons.favorite,
      'color': Colors.redAccent,
      'screen': const RopeScreen(),
      'scaleName': 'RoPE',
      'category': 'Emergencial',
    },

    // --- Ambulatory Scores ---
    {
      'title': 'Barthel Index',
      'subtitle': 'Índice de Barthel\nAvaliação de atividades de vida diária',
      'icon': Icons.accessibility_new,
      'color': Colors.teal,
      'screen': const BarthelScreen(),
      'scaleName': 'Barthel',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Rivermead Mobility Index',
      'subtitle': 'Índice de Mobilidade de Rivermead\nAvaliação de mobilidade funcional',
      'icon': Icons.directions_walk,
      'color': Colors.blueGrey,
      'screen': const RMIScreen(),
      'scaleName': 'RMI',
      'category': 'Ambulatorial',
    },
    {
      'title': 'SCAT',
      'subtitle': 'Sport Concussion Assessment Tool\nAvaliação de concussão esportiva',
      'icon': Icons.sports_baseball,
      'color': Colors.lightBlue,
      'screen': const SCATScreen(),
      'scaleName': 'SCAT',
      'category': 'Ambulatorial',
    },
    {
      'title': 'PCSS',
      'subtitle': 'Post-Concussion Symptom Scale\nEscala de sintomas pós-concussão',
      'icon': Icons.psychology,
      'color': Colors.tealAccent,
      'screen': const PCSSScreen(),
      'scaleName': 'PCSS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'ABC Scale',
      'subtitle': 'Activities-Specific Balance Confidence\nAvaliação de confiança no equilíbrio',
      'icon': Icons.balance,
      'color': Colors.indigo,
      'screen': const ABCScreen(),
      'scaleName': 'ABC',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Berg Balance Scale',
      'subtitle': 'Escala de Equilíbrio de Berg\nAvaliação de equilíbrio funcional',
      'icon': Icons.straighten,
      'color': Colors.deepPurple,
      'screen': const BergScreen(),
      'scaleName': 'Berg',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Tinetti Balance Assessment',
      'subtitle': 'Avaliação de Equilíbrio Tinetti\nAvaliação de equilíbrio e marcha',
      'icon': Icons.trending_up,
      'color': Colors.brown,
      'screen': const TinettiScreen(),
      'scaleName': 'Tinetti',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Functional Gait Assessment',
      'subtitle': 'Avaliação Funcional da Marcha\nAvaliação de marcha funcional',
      'icon': Icons.directions_run,
      'color': Colors.amber,
      'screen': const FGAScreen(),
      'scaleName': 'FGA',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Timed Up & Go (TUG)',
      'subtitle': 'Teste de Mobilidade e Risco de Queda\nAvaliação de mobilidade',
      'icon': Icons.timer,
      'color': Colors.pink,
      'screen': const TUGScreen(),
      'scaleName': 'TUG',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Dizziness Handicap Inventory',
      'subtitle': 'Inventário de Incapacidade por Tontura\nAvaliação do impacto da tontura',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.purple,
      'screen': const DHIScreen(),
      'scaleName': 'DHI',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Mini-Mental State Examination (MMSE)',
      'subtitle': 'Exame do Estado Mental\nAvaliação cognitiva (0-30 pontos)',
      'icon': Icons.psychology,
      'color': Colors.blue,
      'screen': const MMSEScreen(),
      'scaleName': 'MMSE',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Montreal Cognitive Assessment (MoCA)',
      'subtitle': 'Avaliação Cognitiva de Montreal\nAvaliação cognitiva abrangente (0-30 pontos)',
      'icon': Icons.memory,
      'color': Colors.purple,
      'screen': const MoCAScreen(),
      'scaleName': 'MoCA',
      'category': 'Ambulatorial',
    },
    {
      'title': 'ACE-III',
      'subtitle': 'Addenbrooke\'s Cognitive Examination\nAvaliação cognitiva abrangente (0-100 pontos)',
      'icon': Icons.psychology_outlined,
      'color': Colors.teal,
      'screen': const ACEIIIScreen(),
      'scaleName': 'ACE-III',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Bateria Breve Nitrini',
      'subtitle': 'Avaliação Cognitiva Brasileira\nAdaptada para baixa escolaridade',
      'icon': Icons.book,
      'color': Colors.amber,
      'screen': const NitriniScreen(),
      'scaleName': 'Nitrini',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Hoehn and Yahr Scale',
      'subtitle': 'Estágios da Doença de Parkinson\nClassificação de estágios (0-5)',
      'icon': Icons.directions_walk,
      'color': Colors.brown,
      'screen': const HoehnYahrScreen(),
      'scaleName': 'Hoehn Yahr',
      'category': 'Ambulatorial',
    },
    {
      'title': 'UPDRS',
      'subtitle': 'Unified Parkinson\'s Disease Rating Scale\nAvaliação completa da doença de Parkinson',
      'icon': Icons.assessment,
      'color': Colors.purple,
      'screen': const UPDRSScreen(),
      'scaleName': 'UPDRS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'MDS-UPDRS',
      'subtitle': 'Movement Disorder Society-UPDRS\nVersão revisada da UPDRS',
      'icon': Icons.trending_up,
      'color': Colors.deepPurple,
      'screen': const MDSUPDRSScreen(),
      'scaleName': 'MDS-UPDRS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'TESTE DA LEVODOPA',
      'subtitle': 'MDS-UPDRS Parte III\nAvaliação motora para teste de levodopa',
      'icon': Icons.timer,
      'color': Colors.teal,
      'screen': const MDSUPDRSScreen(onlyPart3: true),
      'scaleName': 'TESTE DA LEVODOPA',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Tremor Rating Scale',
      'subtitle': 'Escala de Avaliação de Tremor\nAvaliação de tremor de repouso, postural e cinético',
      'icon': Icons.vibration,
      'color': Colors.brown,
      'screen': const TremorRatingScreen(),
      'scaleName': 'Tremor Rating',
      'category': 'Ambulatorial',
    },
    {
      'title': 'NMSS',
      'subtitle': 'Non-Motor Symptoms Scale\nAvaliação de sintomas não motores (30 itens)',
      'icon': Icons.sentiment_satisfied_alt,
      'color': Colors.lightBlue,
      'screen': const NMSSScreen(),
      'scaleName': 'NMSS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'PDQ-39',
      'subtitle': 'Parkinson\'s Disease Questionnaire\nQuestionário de qualidade de vida (39 itens)',
      'icon': Icons.description,
      'color': Colors.pink,
      'screen': const PDQ39Screen(),
      'scaleName': 'PDQ-39',
      'category': 'Ambulatorial',
    },
    {
      'title': 'ALSFRS-R',
      'subtitle': 'Amyotrophic Lateral Sclerosis Functional Rating Scale\nAvaliação funcional de ELA (12 itens)',
      'icon': Icons.accessibility,
      'color': Colors.red,
      'screen': const ALSFRSRScreen(),
      'scaleName': 'ALSFRS-R',
      'category': 'Ambulatorial',
    },
    {
      'title': 'EDSS',
      'subtitle': 'Expanded Disability Status Scale\nEscala expandida do status de incapacidade (0-10.0)',
      'icon': Icons.accessible,
      'color': Colors.indigo,
      'screen': const EDSSScreen(),
      'scaleName': 'EDSS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'MSFC',
      'subtitle': 'Multiple Sclerosis Functional Composite\nComposto funcional de esclerose múltipla',
      'icon': Icons.functions,
      'color': Colors.cyan,
      'screen': const MSFCScreen(),
      'scaleName': 'MSFC',
      'category': 'Ambulatorial',
    },
    {
      'title': 'MSIS-29',
      'subtitle': 'Multiple Sclerosis Impact Scale\nEscala de impacto da esclerose múltipla (29 itens)',
      'icon': Icons.trending_up,
      'color': Colors.cyan,
      'screen': const MSIS29Screen(),
      'scaleName': 'MSIS-29',
      'category': 'Ambulatorial',
    },
    {
      'title': 'MRC Scale',
      'subtitle': 'Medical Research Council Scale\nAvaliação de força muscular (0-5)',
      'icon': Icons.fitness_center,
      'color': Colors.green,
      'screen': const MRCScreen(),
      'scaleName': 'MRC',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Myopathy Severity Scale',
      'subtitle': 'Escala de Severidade de Miopatia\nAvaliação de miopatia',
      'icon': Icons.warning,
      'color': Colors.red,
      'screen': const MyopathySeverityScreen(),
      'scaleName': 'Myopathy Severity',
      'category': 'Ambulatorial',
    },
    {
      'title': 'CMTNS',
      'subtitle': 'Charcot-Marie-Tooth Neuropathy Score\nEscala de neuropatia de Charcot-Marie-Tooth',
      'icon': Icons.bug_report,
      'color': Colors.deepOrange,
      'screen': const CMTNSScreen(),
      'scaleName': 'CMTNS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Fatigue Severity Scale (FSS)',
      'subtitle': 'Escala de Severidade de Fadiga\nAvaliação de fadiga (9 itens)',
      'icon': Icons.battery_charging_full,
      'color': Colors.orange,
      'screen': const FSSScreen(),
      'scaleName': 'FSS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Clock Drawing Test (CDT)',
      'subtitle': 'Teste do Desenho do Relógio\nAvaliação cognitiva visuoespacial',
      'icon': Icons.schedule,
      'color': Colors.blue,
      'screen': const CDTScreen(),
      'scaleName': 'CDT',
      'category': 'Ambulatorial',
    },
    {
      'title': 'PHQ-9',
      'subtitle': 'Patient Health Questionnaire-9\nAvaliação de depressão (9 itens)',
      'icon': Icons.mood_bad,
      'color': Colors.blue,
      'screen': const PHQ9Screen(),
      'scaleName': 'PHQ-9',
      'category': 'Ambulatorial',
    },
    {
      'title': 'GAD-7',
      'subtitle': 'Generalized Anxiety Disorder-7\nAvaliação de ansiedade (7 itens)',
      'icon': Icons.mood_bad,
      'color': Colors.purple,
      'screen': const GAD7Screen(),
      'scaleName': 'GAD-7',
      'category': 'Ambulatorial',
    },
    {
      'title': 'GDS-15',
      'subtitle': 'Geriatric Depression Scale\nAvaliação de depressão em idosos (15 itens)',
      'icon': Icons.people,
      'color': Colors.teal,
      'screen': const GDSScreen(),
      'scaleName': 'GDS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Epworth Sleepiness Scale',
      'subtitle': 'ESS\nAvaliação de sonolência diurna (8 situações)',
      'icon': Icons.bedtime,
      'color': Colors.indigo,
      'screen': const ESSScreen(),
      'scaleName': 'ESS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'VAS - Dor',
      'subtitle': 'Visual Analog Scale\nAvaliação de intensidade de dor (0-10)',
      'icon': Icons.linear_scale,
      'color': Colors.red,
      'screen': const VASScreen(),
      'scaleName': 'VAS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'MIDAS',
      'subtitle': 'Migraine Disability Assessment\nAvaliação de incapacidade por enxaqueca',
      'icon': Icons.healing,
      'color': Colors.deepPurple,
      'screen': const MIDASScreen(),
      'scaleName': 'MIDAS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'HIT-6',
      'subtitle': 'Headache Impact Test\nAvaliação de impacto da cefaleia (6 itens)',
      'icon': Icons.warning_amber,
      'color': Colors.amber,
      'screen': const HIT6Screen(),
      'scaleName': 'HIT-6',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Lawton IADL Scale',
      'subtitle': 'Instrumental Activities of Daily Living\nAvaliação de atividades instrumentais (8 itens)',
      'icon': Icons.home_work,
      'color': Colors.green,
      'screen': const LawtonIADLScreen(),
      'scaleName': 'Lawton IADL',
      'category': 'Ambulatorial',
    },
    {
      'title': 'BIMS',
      'subtitle': 'Brief Interview for Mental Status\nAvaliação cognitiva breve (15 pontos)',
      'icon': Icons.question_answer,
      'color': Colors.blue,
      'screen': const BIMSScreen(),
      'scaleName': 'BIMS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'SDMT',
      'subtitle': 'Symbol Digit Modalities Test\nTeste de velocidade de processamento (90s)',
      'icon': Icons.speed,
      'color': Colors.cyan,
      'screen': const SDMTScreen(),
      'scaleName': 'SDMT',
      'category': 'Ambulatorial',
    },
    {
      'title': 'HAM-D / HDRS',
      'subtitle': 'Hamilton Depression Rating Scale\nAvaliação clínica de depressão (17 itens)',
      'icon': Icons.psychology,
      'color': Colors.blue,
      'screen': const HAMDScreen(),
      'scaleName': 'HAM-D',
      'category': 'Ambulatorial',
    },
    {
      'title': 'SMFQ',
      'subtitle': 'Short Mood and Feelings Questionnaire\nAvaliação de depressão em crianças/adolescentes',
      'icon': Icons.child_care,
      'color': Colors.pink,
      'screen': const SMFQScreen(),
      'scaleName': 'SMFQ',
      'category': 'Ambulatorial',
    },
    {
      'title': 'HDI',
      'subtitle': 'Headache Disability Inventory\nAvaliação de incapacidade por cefaleia (25 itens)',
      'icon': Icons.report_problem,
      'color': Colors.brown,
      'screen': const HDIScreen(),
      'scaleName': 'HDI',
      'category': 'Ambulatorial',
    },
    {
      'title': 'Pain Catastrophizing Scale',
      'subtitle': 'PCS\nAvaliação de pensamentos catastróficos (13 itens)',
      'icon': Icons.local_fire_department,
      'color': Colors.deepPurple,
      'screen': const PainCatastrophizingScreen(),
      'scaleName': 'PCS',
      'category': 'Ambulatorial',
    },
    {
      'title': 'SF-MPQ',
      'subtitle': 'Short-Form McGill Pain Questionnaire\nAvaliação qualitativa da dor (15 descritores)',
      'icon': Icons.local_hospital,
      'color': Colors.deepOrange,
      'screen': const SFMPQScreen(),
      'scaleName': 'SF-MPQ',
      'category': 'Ambulatorial',
    },
    {
      'title': 'ICHD-3',
      'subtitle': 'International Classification of Headache Disorders\nClassificação de cefaleias (versão simplificada)',
      'icon': Icons.class_,
      'color': Colors.blueGrey,
      'screen': const ICHDScreen(),
      'scaleName': 'ICHD',
      'category': 'Ambulatorial',
    },
    {
      'title': 'ADAS-Cog',
      'subtitle': 'Alzheimer\'s Disease Assessment Scale-Cognitive\nAvaliação cognitiva para Alzheimer (11 tarefas, 0-70)',
      'icon': Icons.psychology,
      'color': Colors.red,
      'screen': const ADASCogScreen(),
      'scaleName': 'ADAS-Cog',
      'category': 'Ambulatorial',
    },
    {
      'title': 'NPI',
      'subtitle': 'Neuropsychiatric Inventory\nAvaliação de sintomas neuropsiquiátricos (12 domínios)',
      'icon': Icons.medical_services,
      'color': Colors.orange,
      'screen': const NPIScreen(),
      'scaleName': 'NPI',
      'category': 'Ambulatorial',
    },
    {
      'title': 'SF-12',
      'subtitle': 'SF-12 Health Survey\nAvaliação de qualidade de vida relacionada à saúde (12 itens)',
      'icon': Icons.favorite,
      'color': Colors.lime,
      'screen': const SF12Screen(),
      'scaleName': 'SF-12',
      'category': 'Ambulatorial',
    },
    {
      'title': 'WHOQOL-BREF',
      'subtitle': 'World Health Organization Quality of Life\nAvaliação de qualidade de vida (26 itens, 4 domínios)',
      'icon': Icons.spa,
      'color': Colors.green,
      'screen': const WHOQOLBREFScreen(),
      'scaleName': 'WHOQOL-BREF',
      'category': 'Ambulatorial',
    },
    {
      'title': 'PSQI',
      'subtitle': 'Pittsburgh Sleep Quality Index\nAvaliação da qualidade do sono (7 componentes)',
      'icon': Icons.nightlight,
      'color': Colors.indigo,
      'screen': const PSQIScreen(),
      'scaleName': 'PSQI',
      'category': 'Ambulatorial',
    },
  ];
}
