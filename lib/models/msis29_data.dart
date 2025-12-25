class MSIS29Data {
  // Multiple Sclerosis Impact Scale - 29 itens
  // Cada item: 1 (não afetado) a 5 (extremamente afetado)
  
  // Físico (20 itens)
  List<int> fisico; // 20 itens
  
  // Psicológico (9 itens)
  List<int> psicologico; // 9 itens

  MSIS29Data({
    List<int>? fisico,
    List<int>? psicologico,
  })  : fisico = fisico ?? List.filled(20, 1),
        psicologico = psicologico ?? List.filled(9, 1);

  int _getDimensionScore(List<int> items) {
    return items.fold(0, (sum, item) => sum + item);
  }

  int get scoreFisico {
    return _getDimensionScore(fisico);
  }

  int get scorePsicologico {
    return _getDimensionScore(psicologico);
  }

  int get totalScore {
    return scoreFisico + scorePsicologico;
  }

  double _getDimensionPercentage(List<int> items) {
    final minScore = items.length * 1; // Mínimo possível
    final maxScore = items.length * 5; // Máximo possível
    final score = _getDimensionScore(items);
    return ((score - minScore) / (maxScore - minScore)) * 100;
  }

  double get percentualFisico {
    return _getDimensionPercentage(fisico);
  }

  double get percentualPsicologico {
    return _getDimensionPercentage(psicologico);
  }

  double get percentualTotal {
    const minTotal = 29; // 29 itens × 1
    const maxTotal = 145; // 29 itens × 5
    return ((totalScore - minTotal) / (maxTotal - minTotal)) * 100;
  }

  String get interpretation {
    final percentual = percentualTotal;
    if (percentual <= 25) {
      return 'Impacto mínimo na qualidade de vida';
    } else if (percentual <= 50) {
      return 'Impacto moderado na qualidade de vida';
    } else if (percentual <= 75) {
      return 'Impacto significativo na qualidade de vida';
    } else {
      return 'Impacto grave na qualidade de vida';
    }
  }
}
