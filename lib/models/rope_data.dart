class RopeData {
  bool? historicoHipertensao;
  bool? historicoDiabetes;
  bool? historicoAVC_AIT;
  bool? fumante;
  bool? infartoCortical;
  int? idade;

  RopeData({
    this.historicoHipertensao,
    this.historicoDiabetes,
    this.historicoAVC_AIT,
    this.fumante,
    this.infartoCortical,
    this.idade,
  });

  int get score {
    int total = 0;
    
    // Fatores clínicos (Ausência = 1 ponto, Presença = 0)
    if (historicoHipertensao == false) total++;
    if (historicoDiabetes == false) total++;
    if (historicoAVC_AIT == false) total++;
    if (fumante == false) total++;
    
    // Imagem (Presença de infarto cortical = 1 ponto)
    if (infartoCortical == true) total++;
    
    // Idade
    if (idade != null) {
      if (idade! >= 18 && idade! <= 29) total += 5;
      else if (idade! >= 30 && idade! <= 39) total += 4;
      else if (idade! >= 40 && idade! <= 49) total += 3;
      else if (idade! >= 50 && idade! <= 59) total += 2;
      else if (idade! >= 60 && idade! <= 69) total += 1;
      // >= 70 anos = 0 pontos
    }
    
    return total;
  }

  String get interpretacao {
    // Probabilidade atribuível ao FOP (PFO-attributable fraction)
    if (score <= 3) return "0% (Baixa Probabilidade)";
    if (score == 4) return "38% (Probabilidade Moderada)";
    if (score == 5) return "34% (Probabilidade Moderada)";
    if (score == 6) return "62% (Alta Probabilidade)";
    if (score == 7) return "72% (Alta Probabilidade)";
    if (score == 8) return "84% (Alta Probabilidade)";
    if (score >= 9) return "88% (Alta Probabilidade)";
    return "";
  }

  Map<String, dynamic> toJson() {
    return {
      'historicoHipertensao': historicoHipertensao,
      'historicoDiabetes': historicoDiabetes,
      'historicoAVC_AIT': historicoAVC_AIT,
      'fumante': fumante,
      'infartoCortical': infartoCortical,
      'idade': idade,
    };
  }

  factory RopeData.fromJson(Map<String, dynamic> json) {
    return RopeData(
      historicoHipertensao: json['historicoHipertensao'],
      historicoDiabetes: json['historicoDiabetes'],
      historicoAVC_AIT: json['historicoAVC_AIT'],
      fumante: json['fumante'],
      infartoCortical: json['infartoCortical'],
      idade: json['idade'],
    );
  }
}
