class TremorRatingData {
  // Tremor Rating Scale - Baseado em Fahn-Tolosa-Marin
  // Parte A: Resting Tremor (0-4 cada)
  int restingFace;
  int restingJaw;
  int restingTongue;
  int restingLeftArm;
  int restingRightArm;
  int restingLeftLeg;
  int restingRightLeg;
  
  // Parte B: Action/Postural Tremor (0-4 cada)
  int posturalLeftArm;
  int posturalRightArm;
  
  // Parte C: Kinetic Tremor (0-4 cada)
  int kineticLeftArm;
  int kineticRightArm;
  
  // Parte D: Handwriting (0-4)
  int handwriting;
  
  // Parte E: Activities of Daily Living (0-4)
  int atividadesVidaDiaria;

  TremorRatingData({
    this.restingFace = 0,
    this.restingJaw = 0,
    this.restingTongue = 0,
    this.restingLeftArm = 0,
    this.restingRightArm = 0,
    this.restingLeftLeg = 0,
    this.restingRightLeg = 0,
    this.posturalLeftArm = 0,
    this.posturalRightArm = 0,
    this.kineticLeftArm = 0,
    this.kineticRightArm = 0,
    this.handwriting = 0,
    this.atividadesVidaDiaria = 0,
  });

  int get restingTremorScore {
    return restingFace + restingJaw + restingTongue + 
        restingLeftArm + restingRightArm + restingLeftLeg + restingRightLeg;
  }

  int get posturalTremorScore {
    return posturalLeftArm + posturalRightArm;
  }

  int get kineticTremorScore {
    return kineticLeftArm + kineticRightArm;
  }

  int get totalScore {
    return restingTremorScore + posturalTremorScore + kineticTremorScore +
        handwriting + atividadesVidaDiaria;
  }

  String get interpretation {
    final total = totalScore;
    if (total <= 10) {
      return 'Tremor leve';
    } else if (total <= 25) {
      return 'Tremor moderado';
    } else {
      return 'Tremor grave';
    }
  }
}
