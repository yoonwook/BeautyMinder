import 'dart:ffi';

class SurveyWrapper {
  Map<String, BaumannSurveys> surveys;

  SurveyWrapper({required this.surveys});

  factory SurveyWrapper.fromJson(Map<String, dynamic> json) {
    Map<String, BaumannSurveys> surveysMap = json.map((key, value) =>
        MapEntry(key, BaumannSurveys.fromJson(value)));

    return SurveyWrapper(surveys: surveysMap);
  }

  Map<String, dynamic> toJson() {
    return surveys.map((key, value) => MapEntry(key, value.toJson()));
  }
}

class BaumannSurveys {
  final String questionKr;
  final List<Option> options;

  BaumannSurveys({
    required this.questionKr,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_kr': questionKr,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }

  factory BaumannSurveys.fromJson(Map<String, dynamic> json) {
    return BaumannSurveys(
      questionKr: json['question_kr'],
      options: (json['options'] as List).map((item) => Option.fromJson(item)).toList(),
    );
  }
}

class Option {
  final int option;
  final String description;

  Option({
    required this.option,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'description': description,
    };
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      option: json['option'],
      description: json['description'],
    );
  }
}








//////
class ResultWrapper {
  Map<String, BaumannResultInfo> results;

  ResultWrapper({required this.results});

  factory ResultWrapper.fromJson(Map<String, dynamic> json) {
    Map<String, BaumannResultInfo> resultMap = json.map((key, value) =>
        MapEntry(key, BaumannResultInfo.fromJson(value)));

    return ResultWrapper(results: resultMap);
  }

  Map<String, dynamic> toJson() {
    return results.map((key, value) => MapEntry(key, value.toJson()));
  }
}

class BaumannResultInfo {
  final String skintype;
  final List<Scores> scores;
  final List<MetaDatas> metadatas;

  BaumannResultInfo({
    required this.skintype,
    required this.scores,
    required this.metadatas,
  });

  Map<String, dynamic> toJson() {
    return {
      'skintype': skintype,
      'scores': scores.map((option) => option.toJson()).toList(),
      'metadatas': metadatas.map((option) => option.toJson()).toList(),
    };
  }

  factory BaumannResultInfo.fromJson(Map<String, dynamic> json) {
    return BaumannResultInfo(
      skintype: json['skintype'],
      scores: (json['scores'] as List).map((item) => Scores.fromJson(item)).toList(),
      metadatas: (json['metadatas'] as List).map((item) => MetaDatas.fromJson(item)).toList(),
    );
  }
}


class SkinType {
  final String skinType;

  SkinType({
    required this.skinType,
  });

  Map<String, dynamic> toJson() {
    return {
      'skinType': skinType,
    };
  }

  factory SkinType.fromJson(Map<String, dynamic> json) {
    return SkinType(
      skinType: json['skinType'],
    );
  }
}


class Scores {
  final Float hydration;
  final Float sensitivity;
  final Float pigmentation;
  final Float elasticity;
  final Float moistureRetention;

  Scores({
    required this.hydration,
    required this.sensitivity,
    required this.pigmentation,
    required this.elasticity,
    required this.moistureRetention,
  });

  Map<String, dynamic> toJson() {
    return {
      'hydration': hydration,
      'sensitivity': sensitivity,
      'pigmentation': pigmentation,
      'elasticity': elasticity,
      'moistureRetention': moistureRetention,
    };
  }

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      hydration: json['hydration'],
      sensitivity: json['sensitivity'],
      pigmentation: json['pigmentation'],
      elasticity: json['elasticity'],
      moistureRetention: json['moistureRetention'],
    );
  }
}


class MetaDatas {
  final Int hydrationMax;
  final Int sensitivityMax;
  final Int pigmentationMax;
  final Int elasticityMax;

  MetaDatas({
    required this.hydrationMax,
    required this.sensitivityMax,
    required this.pigmentationMax,
    required this.elasticityMax,
  });

  Map<String, dynamic> toJson() {
    return {
      'hydrationMax': hydrationMax,
      'sensitivityMax': sensitivityMax,
      'pigmentationMax': pigmentationMax,
      'elasticityMax': elasticityMax,
    };
  }

  factory MetaDatas.fromJson(Map<String, dynamic> json) {
    return MetaDatas(
      hydrationMax: json['hydrationMax'],
      sensitivityMax: json['sensitivityMax'],
      pigmentationMax: json['pigmentationMax'],
      elasticityMax: json['elasticityMax'],
    );
  }
}