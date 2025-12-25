class ALSFRSRData {
  // Itens funcionais (0-4 cada, onde 4 = normal, 0 = perda completa)
  int fala; // 1. Fala
  int salivacao; // 2. Salivação
  int degluticao; // 3. Deglutição
  int escrita; // 4. Escrita/Escrita à mão
  int cortarComUtensilios; // 5. Cortar alimentos e manusear utensílios (com ou sem adaptação)
  int vestirEHigiene; // 6. Vestir-se e higiene
  int virarNaCamaEAjustarRoupas; // 7. Virar na cama e ajustar roupas
  int caminhar; // 8. Caminhar
  int subirEscadas; // 9. Subir escadas
  int dispneia; // 10. Dispneia
  int ortopneia; // 11. Ortopneia
  int insuficienciaRespiratoria; // 12. Insuficiência respiratória

  ALSFRSRData({
    this.fala = 4,
    this.salivacao = 4,
    this.degluticao = 4,
    this.escrita = 4,
    this.cortarComUtensilios = 4,
    this.vestirEHigiene = 4,
    this.virarNaCamaEAjustarRoupas = 4,
    this.caminhar = 4,
    this.subirEscadas = 4,
    this.dispneia = 4,
    this.ortopneia = 4,
    this.insuficienciaRespiratoria = 4,
  });

  int get totalScore {
    return fala + salivacao + degluticao + escrita + cortarComUtensilios +
        vestirEHigiene + virarNaCamaEAjustarRoupas + caminhar + subirEscadas +
        dispneia + ortopneia + insuficienciaRespiratoria;
  }

  int get scoreBulbar {
    return fala + salivacao + degluticao;
  }

  int get scoreMotorFino {
    return escrita + cortarComUtensilios;
  }

  int get scoreMotorGrosso {
    return vestirEHigiene + virarNaCamaEAjustarRoupas + caminhar + subirEscadas;
  }

  int get scoreRespiratorio {
    return dispneia + ortopneia + insuficienciaRespiratoria;
  }

  String get interpretation {
    final total = totalScore;
    if (total >= 40) {
      return 'Funcionalidade preservada - Doença leve';
    } else if (total >= 30) {
      return 'Funcionalidade moderadamente comprometida - Doença moderada';
    } else if (total >= 20) {
      return 'Funcionalidade significativamente comprometida - Doença moderada a grave';
    } else {
      return 'Funcionalidade gravemente comprometida - Doença grave';
    }
  }
}
