class CPPData {
  double pressaoArterialMedia; // mmHg
  double pressaoIntracraniana; // mmHg

  CPPData({
    this.pressaoArterialMedia = 80.0,
    this.pressaoIntracraniana = 10.0,
  });

  double get cpp {
    return pressaoArterialMedia - pressaoIntracraniana;
  }

  String get interpretacao {
    final cppValue = cpp;
    if (cppValue >= 70 && cppValue <= 100) return 'CPP Adequado - Perfusão cerebral normal';
    if (cppValue >= 60 && cppValue < 70) return 'CPP Limítrofe - Monitorização intensiva recomendada';
    if (cppValue >= 50 && cppValue < 60) return 'CPP Baixo - Risco de isquemia cerebral';
    if (cppValue < 50) return 'CPP Crítico - Isquemia cerebral grave, tratamento urgente necessário';
    if (cppValue > 100) return 'CPP Elevado - Risco de hiperperfusão e edema';
    return 'CPP fora dos parâmetros ideais';
  }

  String get conduta {
    final cppValue = cpp;
    if (cppValue < 50) {
      return 'Tratamento urgente: Aumentar PAM (fluidos, vasopressores), reduzir ICP se possível';
    }
    if (cppValue < 60) {
      return 'Otimizar: Manter PAM ≥ 80mmHg, reduzir ICP, monitorizar continuamente';
    }
    if (cppValue > 100) {
      return 'Considerar redução de PAM ou controle de ICP para evitar hiperperfusão';
    }
    return 'Manter CPP entre 70-100mmHg - Monitorização contínua';
  }
}

