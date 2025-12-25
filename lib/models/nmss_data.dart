// Classe auxiliar para armazenar frequência e severidade
class NMSSItem {
  int frequencia; // 1-4 (nunca, raramente, às vezes, frequentemente)
  int severidade; // 0-3 (nenhuma, leve, moderada, grave)
  
  NMSSItem({this.frequencia = 1, this.severidade = 0});
  
  int get score => frequencia * severidade;
}

class NMSSData {
  // Non-Motor Symptoms Scale - 30 itens em 9 domínios
  // Cada item tem frequência (1-4) × severidade (0-3) = score 0-12
  
  // Domínio 1: Cardiovascular (incluindo tontura) - 1 item
  NMSSItem cardiovascular;
  
  // Domínio 2: Sono/Fadiga - 4 itens
  NMSSItem sonoInsonia;
  NMSSItem sonoSonolencia;
  NMSSItem sonoRls;
  NMSSItem fadiga;
  
  // Domínio 3: Humor/Cognição - 6 itens
  NMSSItem interesseMotivacao;
  NMSSItem prazer;
  NMSSItem depressao;
  NMSSItem ansiedade;
  NMSSItem delusao;
  NMSSItem alucinacao;
  
  // Domínio 4: Percepção/Problemas - 2 itens
  NMSSItem visao;
  NMSSItem delusaoAlucinacao;
  
  // Domínio 5: Atenção/Memória - 3 itens
  NMSSItem concentracao;
  NMSSItem memoria;
  NMSSItem esquecimento;
  
  // Domínio 6: Trato Gastrointestinal - 3 itens
  NMSSItem salivacao;
  NMSSItem degluticao;
  NMSSItem nausea;
  
  // Domínio 7: Urinário - 3 itens
  NMSSItem urinaFrequencia;
  NMSSItem urinaNocturia;
  NMSSItem urinaIncontinencia;
  
  // Domínio 8: Função Sexual - 2 itens
  NMSSItem sexualInteresse;
  NMSSItem sexualDisfuncao;
  
  // Domínio 9: Miscelânea - 6 itens
  NMSSItem dor;
  NMSSItem perdaOlfato;
  NMSSItem peso;
  NMSSItem suor;
  NMSSItem quedas;
  NMSSItem sialorreia;

  NMSSData({
    NMSSItem? cardiovascular,
    NMSSItem? sonoInsonia,
    NMSSItem? sonoSonolencia,
    NMSSItem? sonoRls,
    NMSSItem? fadiga,
    NMSSItem? interesseMotivacao,
    NMSSItem? prazer,
    NMSSItem? depressao,
    NMSSItem? ansiedade,
    NMSSItem? delusao,
    NMSSItem? alucinacao,
    NMSSItem? visao,
    NMSSItem? delusaoAlucinacao,
    NMSSItem? concentracao,
    NMSSItem? memoria,
    NMSSItem? esquecimento,
    NMSSItem? salivacao,
    NMSSItem? degluticao,
    NMSSItem? nausea,
    NMSSItem? urinaFrequencia,
    NMSSItem? urinaNocturia,
    NMSSItem? urinaIncontinencia,
    NMSSItem? sexualInteresse,
    NMSSItem? sexualDisfuncao,
    NMSSItem? dor,
    NMSSItem? perdaOlfato,
    NMSSItem? peso,
    NMSSItem? suor,
    NMSSItem? quedas,
    NMSSItem? sialorreia,
  })  : cardiovascular = cardiovascular ?? NMSSItem(),
        sonoInsonia = sonoInsonia ?? NMSSItem(),
        sonoSonolencia = sonoSonolencia ?? NMSSItem(),
        sonoRls = sonoRls ?? NMSSItem(),
        fadiga = fadiga ?? NMSSItem(),
        interesseMotivacao = interesseMotivacao ?? NMSSItem(),
        prazer = prazer ?? NMSSItem(),
        depressao = depressao ?? NMSSItem(),
        ansiedade = ansiedade ?? NMSSItem(),
        delusao = delusao ?? NMSSItem(),
        alucinacao = alucinacao ?? NMSSItem(),
        visao = visao ?? NMSSItem(),
        delusaoAlucinacao = delusaoAlucinacao ?? NMSSItem(),
        concentracao = concentracao ?? NMSSItem(),
        memoria = memoria ?? NMSSItem(),
        esquecimento = esquecimento ?? NMSSItem(),
        salivacao = salivacao ?? NMSSItem(),
        degluticao = degluticao ?? NMSSItem(),
        nausea = nausea ?? NMSSItem(),
        urinaFrequencia = urinaFrequencia ?? NMSSItem(),
        urinaNocturia = urinaNocturia ?? NMSSItem(),
        urinaIncontinencia = urinaIncontinencia ?? NMSSItem(),
        sexualInteresse = sexualInteresse ?? NMSSItem(),
        sexualDisfuncao = sexualDisfuncao ?? NMSSItem(),
        dor = dor ?? NMSSItem(),
        perdaOlfato = perdaOlfato ?? NMSSItem(),
        peso = peso ?? NMSSItem(),
        suor = suor ?? NMSSItem(),
        quedas = quedas ?? NMSSItem(),
        sialorreia = sialorreia ?? NMSSItem();

  int get scoreCardiovascular {
    return cardiovascular.score;
  }

  int get scoreSonoFadiga {
    return sonoInsonia.score + sonoSonolencia.score + sonoRls.score + fadiga.score;
  }

  int get scoreHumorCognicao {
    return interesseMotivacao.score + prazer.score + depressao.score + 
        ansiedade.score + delusao.score + alucinacao.score;
  }

  int get scorePercepcao {
    return visao.score + delusaoAlucinacao.score;
  }

  int get scoreAtencaoMemoria {
    return concentracao.score + memoria.score + esquecimento.score;
  }

  int get scoreGastrointestinal {
    return salivacao.score + degluticao.score + nausea.score;
  }

  int get scoreUrinario {
    return urinaFrequencia.score + urinaNocturia.score + urinaIncontinencia.score;
  }

  int get scoreSexual {
    return sexualInteresse.score + sexualDisfuncao.score;
  }

  int get scoreMiscelanea {
    return dor.score + perdaOlfato.score + peso.score + suor.score + quedas.score + sialorreia.score;
  }

  int get totalScore {
    return scoreCardiovascular + scoreSonoFadiga + scoreHumorCognicao + scorePercepcao +
        scoreAtencaoMemoria + scoreGastrointestinal + scoreUrinario + scoreSexual +
        scoreMiscelanea;
  }

  String get interpretation {
    final total = totalScore;
    if (total <= 20) {
      return 'Sintomas não motores leves';
    } else if (total <= 40) {
      return 'Sintomas não motores moderados';
    } else if (total <= 60) {
      return 'Sintomas não motores moderados a graves';
    } else {
      return 'Sintomas não motores graves';
    }
  }
}