import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'] ?? "",
      number: json['number'] != null ? (json['number'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }

  const NumberTriviaModel({
    required super.text,
    required super.number,
  });
}
