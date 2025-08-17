import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/quiz_provider.dart';

class ResultQuiz extends StatefulWidget {
  const ResultQuiz({super.key});

  @override
  State<ResultQuiz> createState() => _ResultQuizState();
}

class _ResultQuizState extends State<ResultQuiz> {
  ///
  List<Map<String, Object>> data = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final List<Map<String, Object>> args =
        ModalRoute.of(context)!.settings.arguments as List<Map<String, Object>>;
    data = args;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /*App bar content*/
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Quiz Result"),
        centerTitle: false,
      ),

      /*Body content*/
      body: Consumer<QuizProvider>(
        builder: (_, quizProv, _) {
          ///
          int correctAnswers = 0;
          for (var answer in data) {
            if (answer["correct_answer"] == answer["user_answer"]) {
              correctAnswers++;
            }
          }

          ///
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your score: ${correctAnswers.toString()}/${data.length}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                ...data.asMap().entries.map((entry) {
                  // final index = entry.key;
                  Map<String, Object> dataQuiz = entry.value;
                  bool isCorrect = dataQuiz['correct_answer'] == dataQuiz['user_answer'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataQuiz["question"].toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your answer: ${dataQuiz["user_answer"]}",
                        style: TextStyle(
                            fontSize: 16,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Correct answer: ${dataQuiz["correct_answer"]}",
                        style: const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
                MaterialButton(
                  onPressed: () {
                    // todo: add logic to restart quiz
                    quizProv.restartQuiz(context);
                  },
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(width: 1, color: Color(0xffdcdfe3)),
                  ),
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  minWidth: double.infinity,
                  child: const Text(
                    "🔁 Restart Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      /*End of content*/
    );
  }
}
