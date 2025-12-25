class CompletedScore {
  String scoreName; // Nome da escala (ex: "NIHSS", "Glasgow")
  Map<String, dynamic> scoreData; // Dados da escala em formato JSON
  String? resultado; // Resultado/interpretação
  int? totalScore; // Score total se aplicável
  DateTime dataHora; // Data e hora do preenchimento
  String? patientId; // ID do paciente ao qual este score pertence

  CompletedScore({
    required this.scoreName,
    required this.scoreData,
    this.resultado,
    this.totalScore,
    DateTime? dataHora,
    this.patientId,
  }) : dataHora = dataHora ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'scoreName': scoreName,
      'scoreData': scoreData,
      'resultado': resultado,
      'totalScore': totalScore,
      'dataHora': dataHora.toIso8601String(),
      'patientId': patientId,
    };
  }

  factory CompletedScore.fromJson(Map<String, dynamic> json) {
    return CompletedScore(
      scoreName: json['scoreName'],
      scoreData: json['scoreData'],
      resultado: json['resultado'],
      totalScore: json['totalScore'],
      dataHora: DateTime.parse(json['dataHora']),
      patientId: json['patientId'],
    );
  }
}

