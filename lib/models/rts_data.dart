class RTSData {
  int glasgowComaScale; // GCS 3-15
  int pressaoSistolica; // mmHg
  int frequenciaRespiratoria; // resp/min

  RTSData({
    this.glasgowComaScale = 15,
    this.pressaoSistolica = 120,
    this.frequenciaRespiratoria = 20,
  });

  int get gcsCodificado {
    if (glasgowComaScale >= 13) return 4;
    if (glasgowComaScale >= 9) return 3;
    if (glasgowComaScale >= 6) return 2;
    return 1;
  }

  int get pasCodificado {
    if (pressaoSistolica > 89) return 4;
    if (pressaoSistolica >= 76) return 3;
    if (pressaoSistolica >= 50) return 2;
    return 1;
  }

  int get frCodificado {
    if (frequenciaRespiratoria >= 10 && frequenciaRespiratoria <= 29) return 4;
    if (frequenciaRespiratoria > 29) return 3;
    if (frequenciaRespiratoria >= 6) return 2;
    return 1;
  }

  double get rts {
    return (gcsCodificado * 0.9368) + 
           (pasCodificado * 0.7326) + 
           (frCodificado * 0.2908);
  }

  String get interpretacao {
    if (rts >= 10.79) return 'Baixo risco - Sobrevivência esperada >95%';
    if (rts >= 7.84) return 'Risco moderado - Sobrevivência esperada 85-95%';
    if (rts >= 4.09) return 'Alto risco - Sobrevivência esperada 50-85%';
    return 'Risco muito alto - Sobrevivência esperada <50%';
  }
}

