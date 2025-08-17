import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/quiz_provider.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /*App bar content*/
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Quiz Game"),
        centerTitle: false,
      ),

      /*Body content*/
      body: Consumer<QuizProvider>(
        builder: (_, quizProv, _) {
          final quizIndex = quizProv.currentIndexOfQuestion;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Question content here
                Text(
                  quizProv.quizQuestions[quizIndex].question,
                  style: const TextStyle(fontSize: 18),
                ),

                /// Answer content here
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: quizProv.quizQuestions[quizIndex].answers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MaterialButton(
                        onPressed: () {
                          // todo: add logic for answer
                          quizProv.addChoice(index);
                          quizProv.nextQuestion(context);
                        },
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        minWidth: double.infinity,
                        child: Text(
                          quizProv.quizQuestions[quizIndex].answers[index],
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
