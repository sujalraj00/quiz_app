import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:quiz_app/Screens/quiz_screen.dart';
import 'package:quiz_app/Services/quiz_services.dart';
import 'package:quiz_app/models/quiz_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'asset/playquiz.json',
                width: double.infinity,
                height: 400,
                fit: BoxFit.fill,
              ),
              // const Text(
              //   '🎯 Quiz Time!',
              //   style: TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  icon: const Icon(
                    size: 34,
                    weight: 60,
                    Icons.play_arrow,
                    color: Colors.blue,
                  ),
                  label: const Text('Start Quiz',
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  // style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 18, vertical: 15),
                  //     backgroundColor: Colors.white,
                  //     minimumSize: const Size(double.infinity, 60),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    try {
                      final quizService = QuizService();
                      List<QuizQuestion> questions;

                      try {
                        questions = await quizService.fetchQuizQuestions();
                      } catch (e) {
                        print(
                            'regular fetch failed, trying with SSL bypass......');
                        questions = await quizService
                            .fetchQuizQuestionsWithHttpClient();
                      }

                      if (context.mounted && questions.isNotEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(questions: questions)));
                      }
                    } catch (e) {
                      print(e);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error : $e')));
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
