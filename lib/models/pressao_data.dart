class PressaoData {
  int? pas; // Pressão Arterial Sistólica
  int? pad; // Pressão Arterial Diastólica
  bool paBaixaAntesTrombolise; // PA < 185/110 mmHg antes da trombólise
  bool paAltaConsiderarAntihipertensivo; // PA > 220/120 mmHg — considerar antihipertensivo IV
  bool paMediaMonitorar; // PA entre 185–220/110–120 — monitorar sem antihipertensivo
  bool paBaixaEvitarHipotensao; // PA < 140/90 mmHg — evitar hipotensão
  
  double? pesoPaciente;
  bool teveTrombolise;

  PressaoData({
    this.pas,
    this.pad,
    this.paBaixaAntesTrombolise = false,
    this.paAltaConsiderarAntihipertensivo = false,
    this.paMediaMonitorar = false,
    this.paBaixaEvitarHipotensao = false,
    this.pesoPaciente,
    this.teveTrombolise = false,
  });

  String? get classificacaoPressao {
    if (pas == null || pad == null) return null;
    
    if (pas! < 140 && pad! < 90) {
      return 'PA < 140/90 mmHg';
    } else if (pas! < 185 && pad! < 110) {
      return 'PA < 185/110 mmHg';
    } else if (pas! >= 185 && pas! <= 220 && pad! >= 110 && pad! <= 120) {
      return 'PA entre 185–220/110–120 mmHg';
    } else if (pas! > 220 || pad! > 120) {
      return 'PA > 220/120 mmHg';
    }
    
    return 'PA: $pas/$pad mmHg';
  }

  String get conduta {
    if (pas == null || pad == null) {
      return 'Preencha a Pressão Arterial para obter a conduta';
    }

    // Determinar conduta baseada diretamente nos valores
    if (pas! > 220 || pad! > 120) {
      return 'CONDUTA: Considerar antihipertensivo IV\n'
             'Paciente com PA > 220/120 mmHg - requer tratamento imediato.';
    }
    
    if (pas! >= 185 && pas! <= 220 && pad! >= 110 && pad! <= 120) {
      return 'CONDUTA: Monitorar PA sem antihipertensivo\n'
             'Paciente com PA entre 185-220/110-120 mmHg - manter monitoramento.';
    }
    
    if (pas! < 140 && pad! < 90) {
      return 'CONDUTA: Evitar hipotensão\n'
             'Paciente com PA < 140/90 mmHg - monitorar para evitar queda adicional.';
    }
    
    if (pas! < 185 && pad! < 110 && teveTrombolise) {
      return 'CONDUTA: PA adequada antes da trombólise\n'
             'Paciente com PA < 185/110 mmHg - condições adequadas para trombólise.';
    }
    
    return 'CONDUTA: Monitorar pressão arterial\n'
           'Avaliar necessidade de intervenção baseado na evolução clínica.';
  }

  List<String> get criteriosSelecionados {
    List<String> criterios = [];
    
    if (paBaixaAntesTrombolise) {
      criterios.add('PA < 185/110 mmHg antes da trombólise');
    }
    if (paAltaConsiderarAntihipertensivo) {
      criterios.add('PA > 220/120 mmHg — considerar antihipertensivo IV');
    }
    if (paMediaMonitorar) {
      criterios.add('PA entre 185–220/110–120 — monitorar sem antihipertensivo');
    }
    if (paBaixaEvitarHipotensao) {
      criterios.add('PA < 140/90 mmHg — evitar hipotensão');
    }
    
    return criterios;
  }

  void autoDetectarCondicoes() {
    if (pas == null || pad == null) return;
    
    // Auto-detectar baseado nos valores
    if (pas! < 140 && pad! < 90) {
      paBaixaEvitarHipotensao = true;
    } else if (pas! < 185 && pad! < 110) {
      paBaixaAntesTrombolise = true;
    } else if (pas! >= 185 && pas! <= 220 && pad! >= 110 && pad! <= 120) {
      paMediaMonitorar = true;
    } else if (pas! > 220 || pad! > 120) {
      paAltaConsiderarAntihipertensivo = true;
    }
  }
}

