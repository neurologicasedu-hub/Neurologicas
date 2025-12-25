class FSSData {
  // 9 itens da Fatigue Severity Scale (1-7 Likert scale)
  int item1; // Minha motivação é menor quando estou fatigado
  int item2; // O exercício produz sensação de fadiga
  int item3; // Eu me sinto facilmente fatigado
  int item4; // A fadiga interfere com meu funcionamento físico
  int item5; // A fadiga causa frequentes problemas para mim
  int item6; // Minha fadiga impede o desempenho de certas tarefas físicas
  int item7; // A fadiga interfere com a realização de certas responsabilidades
  int item8; // A fadiga está entre meus três sintomas mais incapacitantes
  int item9; // A fadiga interfere com meu trabalho, família ou vida social

  FSSData({
    this.item1 = 1,
    this.item2 = 1,
    this.item3 = 1,
    this.item4 = 1,
    this.item5 = 1,
    this.item6 = 1,
    this.item7 = 1,
    this.item8 = 1,
    this.item9 = 1,
  });

  double get averageScore {
    final total = item1 + item2 + item3 + item4 + item5 + item6 + item7 + item8 + item9;
    return total / 9.0;
  }

  String get interpretation {
    final avg = averageScore;
    if (avg >= 4.0) {
      return 'Fadiga significativa - Impacto importante na vida diária';
    } else if (avg >= 3.0) {
      return 'Fadiga moderada - Algum impacto na vida diária';
    } else {
      return 'Fadiga leve ou ausente - Impacto mínimo';
    }
  }
}
