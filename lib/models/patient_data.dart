class PatientData {
  String id;
  String? nome;
  String? prontuario;
  int? idade;
  String? sexo; // 'M', 'F', 'Outro'
  double? peso; // kg
  double? altura; // cm
  double? imc;
  String? dataAdmissao;
  String? horaAdmissao;
  String? diagnosticoPrincipal;
  String? historicoClinico;
  String? medicacoes;
  String? alergias;

  PatientData({
    String? id,
    this.nome,
    this.prontuario,
    this.idade,
    this.sexo,
    this.peso,
    this.altura,
    this.imc,
    this.dataAdmissao,
    this.horaAdmissao,
    this.diagnosticoPrincipal,
    this.historicoClinico,
    this.medicacoes,
    this.alergias,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Calcula IMC automaticamente
  double? calcularIMC() {
    if (peso != null && altura != null && altura! > 0) {
      final alturaMetros = altura! / 100; // converte cm para metros
      imc = peso! / (alturaMetros * alturaMetros);
      return imc;
    }
    return null;
  }

  // Retorna string formatada do IMC
  String? get imcFormatado {
    final imcValue = calcularIMC();
    if (imcValue == null) return null;
    
    String classificacao = '';
    if (imcValue < 18.5) {
      classificacao = 'Baixo peso';
    } else if (imcValue < 25) {
      classificacao = 'Normal';
    } else if (imcValue < 30) {
      classificacao = 'Sobrepeso';
    } else if (imcValue < 35) {
      classificacao = 'Obesidade Grau I';
    } else if (imcValue < 40) {
      classificacao = 'Obesidade Grau II';
    } else {
      classificacao = 'Obesidade Grau III';
    }
    
    return '${imcValue.toStringAsFixed(1)} ($classificacao)';
  }

  bool get temDadosBasicos {
    return (idade != null && idade! > 0) ||
           (peso != null && peso! > 0) ||
           (altura != null && altura! > 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'prontuario': prontuario,
      'idade': idade,
      'sexo': sexo,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'dataAdmissao': dataAdmissao,
      'horaAdmissao': horaAdmissao,
      'diagnosticoPrincipal': diagnosticoPrincipal,
      'historicoClinico': historicoClinico,
      'medicacoes': medicacoes,
      'alergias': alergias,
    };
  }

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'],
      nome: json['nome'],
      prontuario: json['prontuario'],
      idade: json['idade'],
      sexo: json['sexo'],
      peso: json['peso'],
      altura: json['altura'],
      imc: json['imc'],
      dataAdmissao: json['dataAdmissao'],
      horaAdmissao: json['horaAdmissao'],
      diagnosticoPrincipal: json['diagnosticoPrincipal'],
      historicoClinico: json['historicoClinico'],
      medicacoes: json['medicacoes'],
      alergias: json['alergias'],
    );
  }
}

