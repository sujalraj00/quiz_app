import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/Screens/homepage.dart';
import 'package:quiz_app/models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int currentQuetionIndex = 0;
  int totalScore = 0;
  bool isAnswered = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnswer(QuizOption selectedOption) {
    if (isAnswered) return;
    setState(() {
      isAnswered = true;
      if (selectedOption.isCorrect) {
        totalScore += 10; // Or any scoring logic you want to implement
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuetionIndex < widget.questions.length - 1) {
        setState(() {
          currentQuetionIndex++;
          isAnswered = false;
          _animationController.reset();
          _animationController.forward();
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.blue,
              shadowColor: Colors.blue,
              title: const Text('Quiz Completed!  ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'asset/congrats.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text('Total Score: $totalScore',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text(
                          'Return to Home',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(20),
              minHeight: 10,
              value: _animation.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _animation.value > 0.3 ? Colors.blue : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${currentQuetionIndex + 1}/${widget.questions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.questions[currentQuetionIndex].description,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            ...List.generate(
                widget.questions[currentQuetionIndex].options.length, (index) {
              final option =
                  widget.questions[currentQuetionIndex].options[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isAnswered
                              ? option.isCorrect
                                  ? const Color.fromARGB(255, 0, 255, 8)
                                  : const Color.fromARGB(255, 255, 24, 7)
                              : const Color.fromARGB(255, 58, 166, 255),
                          padding: const EdgeInsets.all(12)),
                      child: Text(option.description,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      onPressed: () => _handleAnswer(option),
                    ),
                  ));
            }),
            const Spacer(),
            Text('Current Score: $totalScore',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!)
          ],
        ),
      ),
    ));
  }
}
