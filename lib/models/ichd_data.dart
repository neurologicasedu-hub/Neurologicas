class ICHD3Data {
  // International Classification of Headache Disorders - 3rd Edition
  // Baseado na documentação oficial do ICHD-3
  
  // Tipo de cefaleia selecionado
  String? tipoCefaleia; // 1.1, 1.2, 2.1, 2.3, 3.1, 3.2, etc.
  
  // ========== MIGRÂNEA SEM AURA (1.1) ==========
  int numeroAtaquesMigranea; // A: ≥5 ataques
  int duracaoAtaque; // B: 4-72 horas
  bool unilateral; // C: Características - unilateral
  bool pulsatil; // C: Características - pulsátil
  bool intensidadeModeradaSevera; // C: Características - moderada/severa
  bool agravaAtividade; // C: Características - agrava com atividade
  bool nauseaVomito; // D: Náusea e/ou vômito
  bool fotofobiaFonofobia; // D: Fotofobia e/ou fonofobia
  
  // ========== MIGRÂNEA COM AURA (1.2) ==========
  int numeroAtaquesMigraneaAura; // A: ≥2 ataques
  String? tipoAura; // Visual, sensorial, disfásica, motora
  int duracaoAura; // C: 5-60 minutos
  bool auraExpandida; // C: Sintomas se expandem gradualmente
  bool auraUnilateral; // C: Sintomas unilaterais
  bool auraPositiva; // C: Sintomas positivos (p.ex., escotoma cintilante)
  bool auraAntesCefaleia; // D: Aura ocorre durante ou antes da cefaleia
  
  // ========== CEFALEIA TIPO TENSÃO EPISÓDICA (2.1) ==========
  int numeroEpisodiosTensao; // A: ≥10 episódios
  int duracaoEpisodioTensao; // B: 30 minutos a 7 dias
  bool tensaoBilateral; // C: Bilateral
  bool tensaoPressao; // C: Qualidade pressão/aperto
  bool tensaoIntensidadeLeveModerada; // C: Intensidade leve a moderada
  bool tensaoNaoAgravaAtividade; // C: Não agrava com atividade física
  bool tensaoNaoNausea; // C: Ausência de náusea/vômito
  bool tensaoNaoFotofonia; // C: Não fotofobia e fonofobia (ou apenas uma)
  
  // ========== CEFALEIA TIPO TENSÃO CRÔNICA (2.3) ==========
  int frequenciaTensaoCronica; // A: ≥15 dias/mês por >3 meses
  int mesesTensaoCronica; // A: ≥3 meses
  bool tensaoCronicaBilateral; // B: Bilateral
  bool tensaoCronicaPressao; // B: Qualidade pressão/aperto
  bool tensaoCronicaIntensidadeLeveModerada; // B: Intensidade leve a moderada
  bool tensaoCronicaNaoAgravaAtividade; // B: Não agrava com atividade física
  bool tensaoCronicaNaoNausea; // B: Ausência de náusea/vômito
  bool tensaoCronicaNaoFotofonia; // B: Não fotofobia e fonofobia (ou apenas uma)
  
  // ========== CEFALEIA EM SALVAS (3.1) ==========
  int numeroAtaquesSalvas; // A: ≥5 ataques
  int duracaoAtaqueSalvas; // B: 15-180 minutos
  int frequenciaSalvas; // B: De 1/2 dias a 8/dia
  bool salvasUnilateral; // C: Unilateral (órbita, supra-orbital e/ou temporal)
  bool salvasSeveraMuitoSevera; // C: Severa ou muito severa
  bool salvasAgitacao; // D: Agitação ou inquietação
  bool salvasSintomasAutonomicos; // D: ≥1 sintoma autonômico ipsilateral
  bool salvasRinorreia; // Sintoma autonômico
  bool salvasObstrucaoNasal; // Sintoma autonômico
  bool salvasPtose; // Sintoma autonômico
  bool salvasLacrimejamento; // Sintoma autonômico
  
  // ========== HEMICRANIA PAROXÍSTICA (3.2) ==========
  int numeroAtaquesHemicrania; // A: ≥5 ataques
  int duracaoAtaqueHemicrania; // B: 2-30 minutos
  int frequenciaHemicrania; // B: ≥5/dia durante >50% do tempo
  bool hemicraniaUnilateral; // C: Unilateral (órbita, temporal ou periorbital)
  bool hemicraniaSeveraMuitoSevera; // C: Severa ou muito severa
  bool hemicraniaSintomasAutonomicos; // D: ≥1 sintoma autonômico ipsilateral
  bool hemicraniaRespondeIndometacina; // D: Responde completamente a indometacina
  
  ICHD3Data({
    this.tipoCefaleia,
    this.numeroAtaquesMigranea = 0,
    this.duracaoAtaque = 0,
    this.unilateral = false,
    this.pulsatil = false,
    this.intensidadeModeradaSevera = false,
    this.agravaAtividade = false,
    this.nauseaVomito = false,
    this.fotofobiaFonofobia = false,
    this.numeroAtaquesMigraneaAura = 0,
    this.tipoAura,
    this.duracaoAura = 0,
    this.auraExpandida = false,
    this.auraUnilateral = false,
    this.auraPositiva = false,
    this.auraAntesCefaleia = false,
    this.numeroEpisodiosTensao = 0,
    this.duracaoEpisodioTensao = 0,
    this.tensaoBilateral = false,
    this.tensaoPressao = false,
    this.tensaoIntensidadeLeveModerada = false,
    this.tensaoNaoAgravaAtividade = false,
    this.tensaoNaoNausea = false,
    this.tensaoNaoFotofonia = false,
    this.frequenciaTensaoCronica = 0,
    this.mesesTensaoCronica = 0,
    this.tensaoCronicaBilateral = false,
    this.tensaoCronicaPressao = false,
    this.tensaoCronicaIntensidadeLeveModerada = false,
    this.tensaoCronicaNaoAgravaAtividade = false,
    this.tensaoCronicaNaoNausea = false,
    this.tensaoCronicaNaoFotofonia = false,
    this.numeroAtaquesSalvas = 0,
    this.duracaoAtaqueSalvas = 0,
    this.frequenciaSalvas = 0,
    this.salvasUnilateral = false,
    this.salvasSeveraMuitoSevera = false,
    this.salvasAgitacao = false,
    this.salvasSintomasAutonomicos = false,
    this.salvasRinorreia = false,
    this.salvasObstrucaoNasal = false,
    this.salvasPtose = false,
    this.salvasLacrimejamento = false,
    this.numeroAtaquesHemicrania = 0,
    this.duracaoAtaqueHemicrania = 0,
    this.frequenciaHemicrania = 0,
    this.hemicraniaUnilateral = false,
    this.hemicraniaSeveraMuitoSevera = false,
    this.hemicraniaSintomasAutonomicos = false,
    this.hemicraniaRespondeIndometacina = false,
  });
  
  // Verificar critérios para Migrânea sem Aura (1.1)
  bool get migraneaSemAuraPreencheCriterios {
    final criterioA = numeroAtaquesMigranea >= 5;
    final criterioB = duracaoAtaque >= 4 && duracaoAtaque <= 72;
    final criterioC = [
      unilateral,
      pulsatil,
      intensidadeModeradaSevera,
      agravaAtividade,
    ].where((c) => c).length >= 2;
    final criterioD = nauseaVomito || fotofobiaFonofobia;
    const criterioE = true; // Não atribuída a outro transtorno (assumido como verdadeiro)
    
    return criterioA && criterioB && criterioC && criterioD && criterioE;
  }
  
  // Verificar critérios para Migrânea com Aura (1.2)
  bool get migraneaComAuraPreencheCriterios {
    final criterioA = numeroAtaquesMigraneaAura >= 2;
    final criterioB = tipoAura != null && tipoAura!.isNotEmpty;
    final criterioC = duracaoAura >= 5 && duracaoAura <= 60 && auraExpandida && auraUnilateral;
    final criterioD = auraAntesCefaleia;
    const criterioE = true; // Não atribuída a outro transtorno
    
    return criterioA && criterioB && criterioC && criterioD && criterioE;
  }
  
  // Verificar critérios para Cefaleia Tipo Tensão Episódica (2.1)
  bool get tensaoEpisodicaPreencheCriterios {
    final criterioA = numeroEpisodiosTensao >= 10;
    final criterioB = duracaoEpisodioTensao >= 30 && duracaoEpisodioTensao <= (7 * 24 * 60); // 7 dias em minutos
    final criterioC = tensaoBilateral && tensaoPressao && tensaoIntensidadeLeveModerada && tensaoNaoAgravaAtividade;
    final criterioD = tensaoNaoNausea && tensaoNaoFotofonia;
    const criterioE = true;
    
    return criterioA && criterioB && criterioC && criterioD && criterioE;
  }
  
  // Verificar critérios para Cefaleia Tipo Tensão Crônica (2.3)
  bool get tensaoCronicaPreencheCriterios {
    final criterioA = frequenciaTensaoCronica >= 15 && mesesTensaoCronica >= 3;
    final criterioB = tensaoCronicaBilateral && tensaoCronicaPressao && tensaoCronicaIntensidadeLeveModerada && tensaoCronicaNaoAgravaAtividade;
    final criterioC = tensaoCronicaNaoNausea && tensaoCronicaNaoFotofonia;
    const criterioD = true;
    
    return criterioA && criterioB && criterioC && criterioD;
  }
  
  // Verificar critérios para Cefaleia em Salvas (3.1)
  bool get salvasPreencheCriterios {
    final criterioA = numeroAtaquesSalvas >= 5;
    final criterioB = duracaoAtaqueSalvas >= 15 && duracaoAtaqueSalvas <= 180 && frequenciaSalvas >= 1;
    final criterioC = salvasUnilateral && salvasSeveraMuitoSevera;
    final criterioD = salvasAgitacao && salvasSintomasAutonomicos;
    const criterioE = true;
    
    return criterioA && criterioB && criterioC && criterioD && criterioE;
  }
  
  // Verificar critérios para Hemicrania Paroxística (3.2)
  bool get hemicraniaParoxisticaPreencheCriterios {
    final criterioA = numeroAtaquesHemicrania >= 5;
    final criterioB = duracaoAtaqueHemicrania >= 2 && duracaoAtaqueHemicrania <= 30 && frequenciaHemicrania >= 5;
    final criterioC = hemicraniaUnilateral && hemicraniaSeveraMuitoSevera;
    final criterioD = hemicraniaSintomasAutonomicos && hemicraniaRespondeIndometacina;
    const criterioE = true;
    
    return criterioA && criterioB && criterioC && criterioD && criterioE;
  }
  
  String get classificacao {
    if (tipoCefaleia == null || tipoCefaleia!.isEmpty) {
      return 'Nenhum tipo selecionado';
    }
    
    switch (tipoCefaleia) {
      case '1.1':
        return migraneaSemAuraPreencheCriterios 
          ? '1.1 Migrânea sem aura' 
          : '1.1 Migrânea sem aura (critérios não preenchidos)';
      case '1.2':
        return migraneaComAuraPreencheCriterios 
          ? '1.2 Migrânea com aura' 
          : '1.2 Migrânea com aura (critérios não preenchidos)';
      case '2.1':
        return tensaoEpisodicaPreencheCriterios 
          ? '2.1 Cefaleia tipo tensão episódica' 
          : '2.1 Cefaleia tipo tensão episódica (critérios não preenchidos)';
      case '2.3':
        return tensaoCronicaPreencheCriterios 
          ? '2.3 Cefaleia tipo tensão crônica' 
          : '2.3 Cefaleia tipo tensão crônica (critérios não preenchidos)';
      case '3.1':
        return salvasPreencheCriterios 
          ? '3.1 Cefaleia em salvas' 
          : '3.1 Cefaleia em salvas (critérios não preenchidos)';
      case '3.2':
        return hemicraniaParoxisticaPreencheCriterios 
          ? '3.2 Hemicrania paroxística' 
          : '3.2 Hemicrania paroxística (critérios não preenchidos)';
      default:
        return 'Tipo não reconhecido';
    }
  }
  
  String get interpretation {
    if (tipoCefaleia == null || tipoCefaleia!.isEmpty) {
      return 'Selecione um tipo de cefaleia para verificar os critérios diagnósticos';
    }
    
    bool preencheCriterios = false;
    switch (tipoCefaleia) {
      case '1.1':
        preencheCriterios = migraneaSemAuraPreencheCriterios;
        break;
      case '1.2':
        preencheCriterios = migraneaComAuraPreencheCriterios;
        break;
      case '2.1':
        preencheCriterios = tensaoEpisodicaPreencheCriterios;
        break;
      case '2.3':
        preencheCriterios = tensaoCronicaPreencheCriterios;
        break;
      case '3.1':
        preencheCriterios = salvasPreencheCriterios;
        break;
      case '3.2':
        preencheCriterios = hemicraniaParoxisticaPreencheCriterios;
        break;
    }
    
    if (preencheCriterios) {
      return '✓ CRITÉRIOS DO ICHD-3 PREENCHIDOS\nDiagnóstico confirmado conforme ICHD-3';
    } else {
      return '⚠ CRITÉRIOS DO ICHD-3 NÃO COMPLETAMENTE PREENCHIDOS\nRevise os critérios acima. Alguns podem estar faltando ou incompletos.';
    }
  }
}
