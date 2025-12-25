class ToastData {
  bool hasMajorCardioembolicSource;
  bool ipsilateralCarotidStenosis50;
  bool lacunarSyndromeClinically;
  double lesionDiameterMm;
  bool otherDeterminedCause;
  bool multiplePotentialCauses;

  ToastData({
    this.hasMajorCardioembolicSource = false,
    this.ipsilateralCarotidStenosis50 = false,
    this.lacunarSyndromeClinically = false,
    this.lesionDiameterMm = 0,
    this.otherDeterminedCause = false,
    this.multiplePotentialCauses = false,
  });

  String get classificacao {
    if (hasMajorCardioembolicSource) {
      return 'Cardioembólico';
    } else if (ipsilateralCarotidStenosis50) {
      return 'Aterosclerose de grandes artérias';
    } else if (lacunarSyndromeClinically && lesionDiameterMm > 0 && lesionDiameterMm <= 15) {
      return 'Oclusão de pequena artéria (lacunar)';
    } else if (otherDeterminedCause) {
      return 'Outra causa determinada';
    } else if (multiplePotentialCauses) {
      return 'Indeterminado (múltiplas causas potenciais)';
    } else {
      return 'Indeterminado (sem causa identificada)';
    }
  }

  String get razao {
    switch (classificacao) {
      case 'Cardioembólico':
        return 'Fonte cardioembólica maior identificada (ex: FA, trombo ventricular)';
      case 'Aterosclerose de grandes artérias':
        return 'Estenose carotídea ipsilateral >=50% ou evidência de placa aterosclerótica correlata';
      case 'Oclusão de pequena artéria (lacunar)':
        return 'Síndrome lacunar clínica com lesão ≤15 mm na imagem';
      case 'Outra causa determinada':
        return 'Causa rara ou específica identificada (ex: dissecção, vasculite)';
      case 'Indeterminado (múltiplas causas potenciais)':
        return 'Encontradas múltiplas causas potenciais ou resultados conflitantes';
      default:
        return 'Nenhuma causa clara encontrada após investigação inicial';
    }
  }
}
