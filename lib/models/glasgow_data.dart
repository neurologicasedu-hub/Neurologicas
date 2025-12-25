class GlasgowData {
  int? ocular;
  int? verbal;
  int? motora;
  int? pupilar;

  GlasgowData({
    this.ocular,
    this.verbal,
    this.motora,
    this.pupilar,
  });

  int get total {
    // Componentes básicos (mínimo 1 se não selecionado, para não quebrar a lógica, mas idealmente deve ser validado na UI)
    int o = ocular ?? 0;
    int v = verbal ?? 0;
    int m = motora ?? 0;
    
    // Soma básica do Glasgow (3 a 15)
    int gcs = o + v + m;

    // Subtração da reatividade pupilar (0 a 2)
    int p = pupilar ?? 0;

    return gcs - p;
  }
  
  // Getter auxiliar para exibir o GCS base sem a subtração da pupila (útil para debug ou exibição detalhada)
  int get gcsBase => (ocular ?? 0) + (verbal ?? 0) + (motora ?? 0);

  String get classificacao {
    // A classificação tradicional baseia-se no GCS padrão (3-15).
    // O GCS-P (com pupila) varia de 1 a 15.
    // Manterei a lógica baseada na pontuação total resultante para simplificação, seguindo guidelines comuns de GCS-P.
    
    // Escala de trauma cranioencefálico leve/moderado/grave geralmente usa GCS base.
    // Mas se o usuário pediu essa conta específica, assumo que a gravidade segue o score final.
    if (total >= 13) return "Leve";
    if (total >= 9) return "Moderado";
    return "Grave";
  }

  String get interpretacaoClinica {
    if (total == 0) return "Sem resposta (Invalido se min GCS=3)"; // Teoricamente impossível com GCS min 3 - 2 = 1.
    if (total >= 13) return "Coma leve ou paciente consciente";
    if (total >= 9 && total <= 12) return "Coma moderado";
    if (total <= 8) return "Coma grave";
    return "Estado crítico";
  }

  Map<String, dynamic> toJson() {
    return {
      'ocular': ocular,
      'verbal': verbal,
      'motora': motora,
      'pupilar': pupilar,
    };
  }

  factory GlasgowData.fromJson(Map<String, dynamic> json) {
    return GlasgowData(
      ocular: json['ocular'],
      verbal: json['verbal'],
      motora: json['motora'],
      pupilar: json['pupilar'],
    );
  }
}
