class LundbergData {
  String tipoOnda; // 'A', 'B', 'C', 'normal'
  double amplitude; // mmHg
  double frequencia; // por minuto
  double duracao; // minutos

  LundbergData({
    this.tipoOnda = 'normal',
    this.amplitude = 0,
    this.frequencia = 0,
    this.duracao = 0,
  });

  String get descricaoOnda {
    switch (tipoOnda) {
      case 'A':
        return 'Ondas A (Plateau): Elevação súbita e sustentada de ICP (50-100 mmHg), duração 5-20 min, altamente patológica';
      case 'B':
        return 'Ondas B: Elevações menores e rítmicas (20-50 mmHg), frequência 0.5-2/min, indicam complacência reduzida';
      case 'C':
        return 'Ondas C: Oscilações rítmicas pequenas (<20 mmHg), relacionadas à respiração e pulso arterial, geralmente normais';
      case 'normal':
        return 'Padrão normal: ICP estável, sem ondas patológicas significativas';
      default:
        return 'Tipo de onda não definido';
    }
  }

  String get interpretacao {
    switch (tipoOnda) {
      case 'A':
        return 'CRÍTICO: Ondas A indicam hipertensão intracraniana severa. Tratamento urgente necessário. Risco alto de hernição e morte';
      case 'B':
        return 'ATENÇÃO: Ondas B sugerem complacência intracraniana reduzida. Monitorização intensiva e consideração de tratamento preventivo';
      case 'C':
        return 'Normal: Ondas C são variações fisiológicas normais relacionadas à respiração e pulso';
      case 'normal':
        return 'Normal: Padrão de ICP dentro dos parâmetros fisiológicos normais';
      default:
        return 'Avaliar características individuais';
    }
  }

  String get condutaRecomendada {
    switch (tipoOnda) {
      case 'A':
        return 'Ação imediata: Hiperventilação, manitol, barbitúricos, avaliação para craniectomia descompressiva, otimização de PPC';
      case 'B':
        return 'Monitorização intensiva: Elevação cabeceira, sedação adequada, manter PPC >60mmHg, considerar tratamento preventivo de segunda linha';
      case 'C':
      case 'normal':
        return 'Continuar monitorização: Manter parâmetros atuais, monitorar tendências';
      default:
        return 'Avaliar caso a caso';
    }
  }
}

