class RMIData {
  int girar; // 0-1
  int sentar; // 0-1
  int levantar; // 0-1
  int manterEmPe; // 0-1
  int transferirCamaCadeira; // 0-1
  int caminhar10m; // 0-1
  int caminhar10mSemAjuda; // 0-1
  int subirEscadas; // 0-1
  int permanecerEmPeSemAjuda; // 0-1
  int sentarSemAjuda; // 0-1
  int levantarSemAjuda; // 0-1
  int caminharFora; // 0-1
  int caminhar5min; // 0-1
  int levantarChao; // 0-1
  int subir4Degraus; // 0-1

  RMIData({
    this.girar = 0,
    this.sentar = 0,
    this.levantar = 0,
    this.manterEmPe = 0,
    this.transferirCamaCadeira = 0,
    this.caminhar10m = 0,
    this.caminhar10mSemAjuda = 0,
    this.subirEscadas = 0,
    this.permanecerEmPeSemAjuda = 0,
    this.sentarSemAjuda = 0,
    this.levantarSemAjuda = 0,
    this.caminharFora = 0,
    this.caminhar5min = 0,
    this.levantarChao = 0,
    this.subir4Degraus = 0,
  });

  int get totalScore {
    return girar +
        sentar +
        levantar +
        manterEmPe +
        transferirCamaCadeira +
        caminhar10m +
        caminhar10mSemAjuda +
        subirEscadas +
        permanecerEmPeSemAjuda +
        sentarSemAjuda +
        levantarSemAjuda +
        caminharFora +
        caminhar5min +
        levantarChao +
        subir4Degraus;
  }

  String get interpretacao {
    if (totalScore >= 13) return 'Mobilidade excelente';
    if (totalScore >= 10) return 'Mobilidade boa';
    if (totalScore >= 7) return 'Mobilidade moderada';
    if (totalScore >= 4) return 'Mobilidade limitada';
    return 'Mobilidade muito limitada';
  }
}

