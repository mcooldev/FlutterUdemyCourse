import 'package:flutter/material.dart';
import 'package:udemy_course/models/questions.dart';

class QuizProvider with ChangeNotifier {
  ///
  final List<Questions> _originalQuizQuestions = [
    Questions('What are the main building blocks of Flutter UIs?', [
      'Widgets',
      'Components',
      'Blocks',
      'Functions',
    ]),
    Questions('How are Flutter UIs built?', [
      'By combining widgets in code',
      'By combining widgets in a visual editor',
      'By defining widgets in config files',
      'By using XCode for iOS and Android Studio for Android',
    ]),
    Questions('What\'s the purpose of a StatefulWidget?', [
      'Update UI as data changes',
      'Update data as UI changes',
      'Ignore data changes',
      'Render UI that does not depend on data',
    ]),
    Questions(
      'Which widget should you try to use more often: StatelessWidget or StatefulWidget?',
      [
        'StatelessWidget',
        'StatefulWidget',
        'Both are equally good',
        'None of the above',
      ],
    ),
    Questions('What happens if you change data in a StatelessWidget?', [
      'The UI is not updated',
      'The UI is updated',
      'The closest StatefulWidget is updated',
      'Any nested StatefulWidgets are updated',
    ]),
    Questions('How should you update data inside of StatefulWidgets?', [
      'By calling setState()',
      'By calling updateData()',
      'By calling updateUI()',
      'By calling updateState()',
    ]),
  ];

  ///
  List<Questions> _quizQuestions = [];

  List<Questions> get quizQuestions => [..._quizQuestions];

  ///
  int currentIndexOfQuestion = 0;
  List<String> correctAnswers = [];

  void starGame(BuildContext context) {
    if (_originalQuizQuestions.isNotEmpty) {
      currentIndexOfQuestion = 0;
      _choices.clear();
      correctAnswers.clear();

      // Create new quiz questions
      _quizQuestions = _originalQuizQuestions
          .map(
            (question) => Questions(question.question, [...question.answers]),
          )
          .toList();

      // Save correct answers
      for (var question in _quizQuestions) {
        correctAnswers.add(question.answers[0]);
      }

      // Shuffle choices
      shuffledChoices();

      // Notify listeners
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No questions available"),
          behavior: SnackBarBehavior.floating,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
  }

  void restartQuiz(BuildContext context) {
    starGame(context);
    //
    Navigator.of(context).pushNamedAndRemoveUntil("/quiz", (route) => false);
  }

  void nextQuestion(BuildContext context) {
    ///
    if ((_quizQuestions.length - 1) > currentIndexOfQuestion) {
      currentIndexOfQuestion++;
      notifyListeners();

      ///
    } else {
      ///
      final List<Map<String, Object>> getSummary = [];
      for (int i = 0; i < _quizQuestions.length; i++) {
        getSummary.add({
          "question_index": i,
          "question": _quizQuestions[i].question,
          "correct_answer": correctAnswers[i],
          "user_answer": _choices[i],
        });
        notifyListeners();
      }

      ///
      Navigator.of(context).pushNamed("/result", arguments: getSummary);
      notifyListeners();
    }
  }

  /// Choices (variables)
  final List<String> _choices = [];

  List<String> get choices => [..._choices];

  /// Get selected answer
  String selectedAnswer(int index) {
    final selected = _quizQuestions[currentIndexOfQuestion].answers[index];
    return selected;
  }

  /// Add choice
  void addChoice(int index) {
    final choseAnswer = selectedAnswer(index);
    _choices.add(choseAnswer);
    notifyListeners();
  }


  /// Shuffle choices
  void shuffledChoices() {
    for (var questions in _quizQuestions) {
      questions.answers.shuffle();
    }
    notifyListeners();
  }

}
