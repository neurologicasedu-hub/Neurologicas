class NitroprussiatoData {
  double pesoPaciente;

  NitroprussiatoData({
    required this.pesoPaciente,
  });

  double get dose {
    // Dose: peso * 0.5 µg/kg/min
    return pesoPaciente * 0.5;
  }

  double get taxaInfusao {
    // Taxa: (dose * 60) / 200 ml/h
    return (dose * 60) / 200;
  }

  String get prescricao {
    return 'Dose: ${dose.toStringAsFixed(2)} µg/kg/min\n'
           'Taxa de infusão: ${taxaInfusao.toStringAsFixed(2)} ml/h';
  }

  String get orientacoes {
    return 'Monitorar PA e ajustar a dose para redução gradual de 10–15% da PA.';
  }
}

