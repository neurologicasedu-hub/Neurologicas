class ACEIIIData {
  // Atenção/Orientação (18 pontos)
  int orientacaoTemporal1; // Data (ano, mês, dia)
  int orientacaoTemporal2;
  int orientacaoTemporal3;
  int orientacaoEspacial1; // Local (cidade, estado, hospital)
  int orientacaoEspacial2;
  int orientacaoEspacial3;
  int repeticaoNumeros; // Repetir números
  int subtracaoSerial; // Subtração seriada por 7
  
  // Memória (26 pontos)
  int nomeEndereco1; // Nome e endereço (aprendizado)
  int nomeEndereco2;
  int nomeEndereco3;
  int nomeEndereco4;
  int nomeEndereco5;
  int nomeEndereco6; // Recordação (mesmo nome e endereço)
  int nomeEndereco7;
  int nomeEndereco8;
  int nomeEndereco9;
  int nomeEndereco10;
  int recordacaoNomeEndereco1; // Recordação tardia
  int recordacaoNomeEndereco2;
  int recordacaoNomeEndereco3;
  int recordacaoNomeEndereco4;
  int recordacaoNomeEndereco5;
  int recordacaoNomeEndereco6;
  int recordacaoNomeEndereco7;
  int recordacaoNomeEndereco8;
  int recordacaoNomeEndereco9;
  int recordacaoNomeEndereco10;
  int recordacaoPalavras1; // Recordação de palavras
  int recordacaoPalavras2;
  int recordacaoPalavras3;
  int recordacaoPalavras4;
  int recordacaoPalavras5;
  int recordacaoPalavras6;
  
  // Fluência Verbal (14 pontos)
  int fluenciaAnimal1;
  int fluenciaAnimal2;
  int fluenciaAnimal3;
  int fluenciaAnimal4;
  int fluenciaAnimal5;
  int fluenciaAnimal6;
  int fluenciaAnimal7;
  int fluenciaAnimal8;
  int fluenciaAnimal9;
  int fluenciaAnimal10;
  int fluenciaAnimal11;
  int fluenciaAnimal12;
  int fluenciaAnimal13;
  int fluenciaAnimal14;
  
  // Linguagem (26 pontos)
  int nomeacaoObjetos1;
  int nomeacaoObjetos2;
  int nomeacaoObjetos3;
  int nomeacaoObjetos4;
  int nomeacaoObjetos5;
  int nomeacaoObjetos6;
  int nomeacaoObjetos7;
  int nomeacaoObjetos8;
  int nomeacaoObjetos9;
  int nomeacaoObjetos10;
  int nomeacaoObjetos11;
  int nomeacaoObjetos12;
  int repeticaoFrases1;
  int repeticaoFrases2;
  int repeticaoFrases3;
  int compreensaoComandos1;
  int compreensaoComandos2;
  int compreensaoComandos3;
  int compreensaoComandos4;
  int leitura1;
  int leitura2;
  int leitura3;
  int leitura4;
  int leitura5;
  int leitura6;
  int leitura7;
  
  // Visuoespacial (16 pontos)
  int copiaFigura1;
  int copiaFigura2;
  int copiaFigura3;
  int copiaFigura4;
  int copiaFigura5;
  int copiaFigura6;
  int copiaFigura7;
  int copiaFigura8;
  int desenhoRelogio1;
  int desenhoRelogio2;
  int desenhoRelogio3;
  int desenhoRelogio4;
  int desenhoRelogio5;
  int desenhoRelogio6;
  int desenhoRelogio7;
  int desenhoRelogio8;

  ACEIIIData({
    this.orientacaoTemporal1 = 0,
    this.orientacaoTemporal2 = 0,
    this.orientacaoTemporal3 = 0,
    this.orientacaoEspacial1 = 0,
    this.orientacaoEspacial2 = 0,
    this.orientacaoEspacial3 = 0,
    this.repeticaoNumeros = 0,
    this.subtracaoSerial = 0,
    this.nomeEndereco1 = 0,
    this.nomeEndereco2 = 0,
    this.nomeEndereco3 = 0,
    this.nomeEndereco4 = 0,
    this.nomeEndereco5 = 0,
    this.nomeEndereco6 = 0,
    this.nomeEndereco7 = 0,
    this.nomeEndereco8 = 0,
    this.nomeEndereco9 = 0,
    this.nomeEndereco10 = 0,
    this.recordacaoNomeEndereco1 = 0,
    this.recordacaoNomeEndereco2 = 0,
    this.recordacaoNomeEndereco3 = 0,
    this.recordacaoNomeEndereco4 = 0,
    this.recordacaoNomeEndereco5 = 0,
    this.recordacaoNomeEndereco6 = 0,
    this.recordacaoNomeEndereco7 = 0,
    this.recordacaoNomeEndereco8 = 0,
    this.recordacaoNomeEndereco9 = 0,
    this.recordacaoNomeEndereco10 = 0,
    this.recordacaoPalavras1 = 0,
    this.recordacaoPalavras2 = 0,
    this.recordacaoPalavras3 = 0,
    this.recordacaoPalavras4 = 0,
    this.recordacaoPalavras5 = 0,
    this.recordacaoPalavras6 = 0,
    this.fluenciaAnimal1 = 0,
    this.fluenciaAnimal2 = 0,
    this.fluenciaAnimal3 = 0,
    this.fluenciaAnimal4 = 0,
    this.fluenciaAnimal5 = 0,
    this.fluenciaAnimal6 = 0,
    this.fluenciaAnimal7 = 0,
    this.fluenciaAnimal8 = 0,
    this.fluenciaAnimal9 = 0,
    this.fluenciaAnimal10 = 0,
    this.fluenciaAnimal11 = 0,
    this.fluenciaAnimal12 = 0,
    this.fluenciaAnimal13 = 0,
    this.fluenciaAnimal14 = 0,
    this.nomeacaoObjetos1 = 0,
    this.nomeacaoObjetos2 = 0,
    this.nomeacaoObjetos3 = 0,
    this.nomeacaoObjetos4 = 0,
    this.nomeacaoObjetos5 = 0,
    this.nomeacaoObjetos6 = 0,
    this.nomeacaoObjetos7 = 0,
    this.nomeacaoObjetos8 = 0,
    this.nomeacaoObjetos9 = 0,
    this.nomeacaoObjetos10 = 0,
    this.nomeacaoObjetos11 = 0,
    this.nomeacaoObjetos12 = 0,
    this.repeticaoFrases1 = 0,
    this.repeticaoFrases2 = 0,
    this.repeticaoFrases3 = 0,
    this.compreensaoComandos1 = 0,
    this.compreensaoComandos2 = 0,
    this.compreensaoComandos3 = 0,
    this.compreensaoComandos4 = 0,
    this.leitura1 = 0,
    this.leitura2 = 0,
    this.leitura3 = 0,
    this.leitura4 = 0,
    this.leitura5 = 0,
    this.leitura6 = 0,
    this.leitura7 = 0,
    this.copiaFigura1 = 0,
    this.copiaFigura2 = 0,
    this.copiaFigura3 = 0,
    this.copiaFigura4 = 0,
    this.copiaFigura5 = 0,
    this.copiaFigura6 = 0,
    this.copiaFigura7 = 0,
    this.copiaFigura8 = 0,
    this.desenhoRelogio1 = 0,
    this.desenhoRelogio2 = 0,
    this.desenhoRelogio3 = 0,
    this.desenhoRelogio4 = 0,
    this.desenhoRelogio5 = 0,
    this.desenhoRelogio6 = 0,
    this.desenhoRelogio7 = 0,
    this.desenhoRelogio8 = 0,
  });

  int get scoreAtencao {
    return orientacaoTemporal1 + orientacaoTemporal2 + orientacaoTemporal3 +
        orientacaoEspacial1 + orientacaoEspacial2 + orientacaoEspacial3 +
        repeticaoNumeros + subtracaoSerial;
  }

  int get scoreMemoria {
    return nomeEndereco1 + nomeEndereco2 + nomeEndereco3 + nomeEndereco4 + nomeEndereco5 +
        nomeEndereco6 + nomeEndereco7 + nomeEndereco8 + nomeEndereco9 + nomeEndereco10 +
        recordacaoNomeEndereco1 + recordacaoNomeEndereco2 + recordacaoNomeEndereco3 +
        recordacaoNomeEndereco4 + recordacaoNomeEndereco5 + recordacaoNomeEndereco6 +
        recordacaoNomeEndereco7 + recordacaoNomeEndereco8 + recordacaoNomeEndereco9 +
        recordacaoNomeEndereco10 +
        recordacaoPalavras1 + recordacaoPalavras2 + recordacaoPalavras3 +
        recordacaoPalavras4 + recordacaoPalavras5 + recordacaoPalavras6;
  }

  int get scoreFluencia {
    return fluenciaAnimal1 + fluenciaAnimal2 + fluenciaAnimal3 + fluenciaAnimal4 +
        fluenciaAnimal5 + fluenciaAnimal6 + fluenciaAnimal7 + fluenciaAnimal8 +
        fluenciaAnimal9 + fluenciaAnimal10 + fluenciaAnimal11 + fluenciaAnimal12 +
        fluenciaAnimal13 + fluenciaAnimal14;
  }

  int get scoreLinguagem {
    return nomeacaoObjetos1 + nomeacaoObjetos2 + nomeacaoObjetos3 + nomeacaoObjetos4 +
        nomeacaoObjetos5 + nomeacaoObjetos6 + nomeacaoObjetos7 + nomeacaoObjetos8 +
        nomeacaoObjetos9 + nomeacaoObjetos10 + nomeacaoObjetos11 + nomeacaoObjetos12 +
        repeticaoFrases1 + repeticaoFrases2 + repeticaoFrases3 +
        compreensaoComandos1 + compreensaoComandos2 + compreensaoComandos3 + compreensaoComandos4 +
        leitura1 + leitura2 + leitura3 + leitura4 + leitura5 + leitura6 + leitura7;
  }

  int get scoreVisuoespacial {
    return copiaFigura1 + copiaFigura2 + copiaFigura3 + copiaFigura4 +
        copiaFigura5 + copiaFigura6 + copiaFigura7 + copiaFigura8 +
        desenhoRelogio1 + desenhoRelogio2 + desenhoRelogio3 + desenhoRelogio4 +
        desenhoRelogio5 + desenhoRelogio6 + desenhoRelogio7 + desenhoRelogio8;
  }

  int get totalScore {
    return scoreAtencao + scoreMemoria + scoreFluencia + scoreLinguagem + scoreVisuoespacial;
  }

  String get interpretation {
    if (totalScore >= 88) {
      return 'Cognição normal';
    } else if (totalScore >= 82) {
      return 'Comprometimento cognitivo muito leve';
    } else if (totalScore >= 70) {
      return 'Comprometimento cognitivo leve';
    } else {
      return 'Comprometimento cognitivo moderado a grave';
    }
  }
}
