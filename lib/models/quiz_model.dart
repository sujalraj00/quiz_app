class QuizQuestion {
  final int id;
  final String description;
  final List<QuizOption> options;
  final String detailedSolution;

  QuizQuestion({
    required this.id,
    required this.description,
    required this.options,
    required this.detailedSolution,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as int,
      description: json['description'] as String,
      options: (json['options'] as List<dynamic>)
          .map((option) => QuizOption.fromJson(option))
          .toList(),
      detailedSolution: json['detailed_solution'] as String? ?? '',
    );
  }
}

class QuizOption {
  final int id;
  final String description;
  final bool isCorrect;

  QuizOption({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as int,
      description: json['description'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }
}
