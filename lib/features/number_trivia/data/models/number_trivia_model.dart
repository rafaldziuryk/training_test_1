import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    final numberText = json['number'];
    final number = int.tryParse(numberText.toString()) ?? 0;
    return NumberTriviaModel(
      text: json['text'] ?? "",
      number: number,
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
