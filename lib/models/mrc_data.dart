class MRCData {
  // Medical Research Council Scale for Muscle Strength
  // Cada grupo muscular: 0-5 (0 = sem contração, 5 = força normal)
  
  // Membros superiores
  int ombroEsquerdo; // Abdução do ombro
  int ombroDireito;
  int cotoveloEsquerdo; // Flexão do cotovelo
  int cotoveloDireito;
  int punhoEsquerdo; // Extensão do punho
  int punhoDireito;
  
  // Membros inferiores
  int quadrilEsquerdo; // Flexão do quadril
  int quadrilDireito;
  int joelhoEsquerdo; // Extensão do joelho
  int joelhoDireito;
  int tornozeloEsquerdo; // Dorsiflexão do tornozelo
  int tornozeloDireito;

  MRCData({
    this.ombroEsquerdo = 5,
    this.ombroDireito = 5,
    this.cotoveloEsquerdo = 5,
    this.cotoveloDireito = 5,
    this.punhoEsquerdo = 5,
    this.punhoDireito = 5,
    this.quadrilEsquerdo = 5,
    this.quadrilDireito = 5,
    this.joelhoEsquerdo = 5,
    this.joelhoDireito = 5,
    this.tornozeloEsquerdo = 5,
    this.tornozeloDireito = 5,
  });

  int get totalScore {
    return ombroEsquerdo + ombroDireito +
        cotoveloEsquerdo + cotoveloDireito +
        punhoEsquerdo + punhoDireito +
        quadrilEsquerdo + quadrilDireito +
        joelhoEsquerdo + joelhoDireito +
        tornozeloEsquerdo + tornozeloDireito;
  }

  double get averageScore {
    return totalScore / 12.0;
  }

  String mrcDescription(int score) {
    switch (score) {
      case 0:
        return '0 - Sem contração visível';
      case 1:
        return '1 - Contração visível ou palpável, sem movimento';
      case 2:
        return '2 - Movimento com gravidade eliminada';
      case 3:
        return '3 - Movimento contra gravidade';
      case 4:
        return '4 - Movimento contra gravidade e resistência';
      case 5:
        return '5 - Força normal';
      default:
        return 'N/A';
    }
  }

  String get interpretation {
    final avg = averageScore;
    if (avg >= 4.5) {
      return 'Força muscular normal ou próxima do normal';
    } else if (avg >= 3.0) {
      return 'Força muscular moderadamente reduzida';
    } else if (avg >= 1.0) {
      return 'Força muscular gravemente reduzida';
    } else {
      return 'Força muscular ausente ou mínima';
    }
  }
}
