class VASData {
  // Visual Analog Scale para dor
  // Escala de 0 (sem dor) a 10 (pior dor imaginável)
  
  int intensidadeDor; // 0-10
  
  VASData({
    this.intensidadeDor = 0,
  });
  
  String get interpretation {
    if (intensidadeDor == 0) {
      return 'Sem dor';
    } else if (intensidadeDor <= 3) {
      return 'Dor leve';
    } else if (intensidadeDor <= 6) {
      return 'Dor moderada';
    } else if (intensidadeDor <= 8) {
      return 'Dor severa';
    } else {
      return 'Dor extremamente severa';
    }
  }
}

