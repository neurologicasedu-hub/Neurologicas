class ICPData {
  double pressaoIntracraniana; // mmHg
  double pressaoArterialMedia; // mmHg

  ICPData({
    this.pressaoIntracraniana = 0,
    this.pressaoArterialMedia = 70,
  });

  double get pressaoPerfusaoCerebralCalculada {
    return pressaoArterialMedia - pressaoIntracraniana;
  }

  String get classificacaoICP {
    if (pressaoIntracraniana < 15) return 'Normal (< 15 mmHg)';
    if (pressaoIntracraniana < 20) return 'Levemente elevada (15-20 mmHg)';
    if (pressaoIntracraniana < 25) return 'Moderadamente elevada (20-25 mmHg)';
    if (pressaoIntracraniana < 35) return 'Severamente elevada (25-35 mmHg)';
    return 'Crítica (> 35 mmHg)';
  }

  String get classificacaoPPC {
    final ppc = pressaoPerfusaoCerebralCalculada;
    if (ppc >= 70) return 'Adequada (≥ 70 mmHg)';
    if (ppc >= 50) return 'Limítrofe (50-70 mmHg)';
    if (ppc >= 40) return 'Inadequada (40-50 mmHg)';
    return 'Crítica (< 40 mmHg)';
  }

  String get conduta {
    if (pressaoIntracraniana >= 25) {
      return 'Tratamento agressivo necessário: Hiperventilação, manitol, barbitúricos, consideração de craniectomia descompressiva';
    }
    if (pressaoIntracraniana >= 20) {
      return 'Monitorização contínua e tratamento de segunda linha: Elevação da cabeceira, sedação, otimização de PPC';
    }
    if (pressaoPerfusaoCerebralCalculada < 60) {
      return 'Otimizar PPC: Manter PAM adequada, ajustar ICP se possível';
    }
    return 'Monitorização contínua - ICP dentro dos parâmetros normais';
  }
}

