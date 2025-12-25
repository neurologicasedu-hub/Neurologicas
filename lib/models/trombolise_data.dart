class TromboliseData {
  bool hemorragiaIntracranianaPrevia;
  bool suspeitaAvcHemorragico;
  bool paAltaNaoControlada;
  bool usoAnticoagulantes;
  bool cirurgiaIntracraniana3Meses;
  bool sangramentoAtivo;
  bool plaquetasBaixas;
  bool glicemiaAnormal;
  bool neoplasiaIntracraniana;
  bool dissecacaoAortica;
  bool idadeAvancada;
  bool nihssAlto;
  bool gravidez;
  bool usoHeparina48h;
  bool cirurgiaMaiorRecente;
  bool iamRecente;
  bool hemorragiaGiRecente;
  
  int? nihssScore;
  double? pesoPaciente;

  TromboliseData({
    this.hemorragiaIntracranianaPrevia = false,
    this.suspeitaAvcHemorragico = false,
    this.paAltaNaoControlada = false,
    this.usoAnticoagulantes = false,
    this.cirurgiaIntracraniana3Meses = false,
    this.sangramentoAtivo = false,
    this.plaquetasBaixas = false,
    this.glicemiaAnormal = false,
    this.neoplasiaIntracraniana = false,
    this.dissecacaoAortica = false,
    this.idadeAvancada = false,
    this.nihssAlto = false,
    this.gravidez = false,
    this.usoHeparina48h = false,
    this.cirurgiaMaiorRecente = false,
    this.iamRecente = false,
    this.hemorragiaGiRecente = false,
    this.nihssScore,
    this.pesoPaciente,
  });

  List<String> get criteriosExclusao {
    List<String> criterios = [];
    
    if (hemorragiaIntracranianaPrevia) criterios.add('Hemorragia intracraniana prévia');
    if (suspeitaAvcHemorragico) criterios.add('Suspeita de AVC hemorrágico');
    if (paAltaNaoControlada) criterios.add('PA > 185x110 mmHg não controlada');
    if (usoAnticoagulantes) criterios.add('Uso atual de anticoagulantes (INR ≥ 1,7 ou TTPa > 40s)');
    if (cirurgiaIntracraniana3Meses) criterios.add('Cirurgia intracraniana ou trauma grave nos últimos 3 meses');
    if (sangramentoAtivo) criterios.add('Sangramento ativo ou distúrbio hemorrágico');
    if (plaquetasBaixas) criterios.add('Plaquetas < 100.000/mm³');
    if (glicemiaAnormal) criterios.add('Glicemia < 50 ou > 400 mg/dL');
    if (neoplasiaIntracraniana) criterios.add('Neoplasia intracraniana conhecida');
    if (dissecacaoAortica) criterios.add('Dissecção aórtica suspeita');
    if (idadeAvancada) criterios.add('Idade > 80 anos');
    if (nihssAlto) criterios.add('NIHSS > 25 (AVC extenso)');
    if (gravidez) criterios.add('Gravidez');
    if (usoHeparina48h) criterios.add('Uso recente de heparina (<48h)');
    if (cirurgiaMaiorRecente) criterios.add('Cirurgia maior recente');
    if (iamRecente) criterios.add('IAM recente (<3 meses)');
    if (hemorragiaGiRecente) criterios.add('Histórico de hemorragia gastrointestinal recente');
    
    return criterios;
  }

  bool get elegivel => criteriosExclusao.isEmpty;

  String get recomendacao {
    if (elegivel) {
      return 'Paciente elegível para trombólise com rtPA';
    } else {
      return 'Paciente NÃO elegível para trombólise - Critérios de exclusão presentes';
    }
  }

  String? get doseRtpa {
    if (!elegivel) return null;
    if (pesoPaciente == null || pesoPaciente! <= 0) return null;
    
    // Dose total de rtPA: 0.9 mg/kg (máximo 90 mg)
    double doseTotal = pesoPaciente! * 0.9;
    if (doseTotal > 90) doseTotal = 90;
    
    // 10% em bolus, 90% em infusão
    double bolus = doseTotal * 0.1;
    double infusao = doseTotal * 0.9;
    double tempoInfusao = 60; // 60 minutos
    
    return 'Dose: ${doseTotal.toStringAsFixed(1)} mg\n'
           'Bolus: ${bolus.toStringAsFixed(1)} mg IV\n'
           'Infusão: ${infusao.toStringAsFixed(1)} mg em ${tempoInfusao.toInt()} min';
  }
}
