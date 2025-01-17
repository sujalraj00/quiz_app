class QuizQuestion {
  final String question;
  final int correctAnswer;
  final int points;
  final List<String> options;

  QuizQuestion(
      {required this.question,
      required this.correctAnswer,
      required this.points,
      required this.options});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
        question: json['question'],
        correctAnswer: json['correctAnswer'],
        options: List<String>.from(json['options']),
        points: json['points'] ?? 10);
  }
}
