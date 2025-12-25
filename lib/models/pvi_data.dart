import 'dart:math';

class PVIData {
  double volumeInjetado; // ml
  double icpInicial; // mmHg
  double icpFinal; // mmHg

  PVIData({
    this.volumeInjetado = 1.0,
    this.icpInicial = 15.0,
    this.icpFinal = 20.0,
  });

  double get pvi {
    if (icpFinal <= icpInicial || icpInicial <= 0) return 0;
    final ratio = icpFinal / icpInicial;
    return volumeInjetado / (log(ratio) / log(10));
  }

  String get interpretacao {
    final pviValue = pvi;
    if (pviValue >= 26) return 'Complacência normal - Boa reserva de espaço intracraniano';
    if (pviValue >= 18) return 'Complacência moderada - Reserva de espaço reduzida';
    if (pviValue >= 13) return 'Complacência reduzida - Risco de hipertensão intracraniana';
    return 'Complacência muito baixa - Risco alto de descompensação';
  }

  String get conduta {
    final pviValue = pvi;
    if (pviValue < 13) {
      return 'Monitorização contínua ICP obrigatória. Considerar tratamento preventivo agressivo.';
    }
    if (pviValue < 18) {
      return 'Monitorização ICP recomendada. Observar tendências.';
    }
    return 'Monitorização padrão - Complacência adequada.';
  }
}

