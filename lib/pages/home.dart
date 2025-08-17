import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/quiz_provider.dart';

import '../widgets/material_btn.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///
  int ratingCount = 0;
  
  void updateRating(int rating) {
    setState(() {
      if (ratingCount == rating) {
        ratingCount = 0;
      } else {
        ratingCount = rating;
      }
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Flutter Udemy Courses"),
        centerTitle: false,
      ),

      /*Body content*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reviewing Flutter Courses",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (i) {
                  final starNumber = i + 1;
                  return IconButton(
                    onPressed: () {
                      // todo: add logic to add rating
                      updateRating(starNumber);
                    },
                    icon: Icon(
                      Icons.star,
                      size: 28,
                      color: starNumber <= ratingCount
                          ? Colors.yellow.shade700
                          : Colors.grey,
                    ),
                  );
                }),
                const Spacer(),
                Text(
                  ratingCount > 0 ? "$ratingCount/5" : "0/5",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Avalaible coures",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            /// Quiz
            MaterialBtn(
              onPressed: () {
                // todo: add logic to start quiz
                Navigator.of(context).pushNamed("/quiz");
                context.read<QuizProvider>().starGame(context);
              },
              btnText: "Start Quiz  🧠",
            ),
            const SizedBox(height: 12),

            /// Expense tracker
            MaterialBtn(
              onPressed: () {
                Navigator.of(context).pushNamed("/expTrackerDashboard");
              },
              btnText: "Expense tracker 💰",
            ),
            const SizedBox(height: 12),
            /// Meals
            MaterialBtn(
              onPressed: () {
                // todo: add logic to start quiz
                Navigator.of(context).pushNamed("/mealsCategory");
              },
              btnText: "Meals categories  🍔",
            ),
            const SizedBox(height: 12),

            /// Shopping list
            MaterialBtn(
              onPressed: () {
                // todo: add logic to start quiz
                Navigator.of(context).pushNamed("/shopping");
              },
              btnText: "Shopping list  🛍️",
            ),
            const SizedBox(height: 12),

            /// Places list
            MaterialBtn(
              onPressed: () {
                // todo: add logic to start quiz
                Navigator.of(context).pushNamed("/placesList");
              },
              btnText: "Places list 📍",
            ),
            const SizedBox(height: 12),

            /// Chat app
            MaterialBtn(
              onPressed: () {
                // todo: add logic to go to chat app
                Navigator.of(context).pushNamed("/authGate");
              },
              btnText: "Chat app  💬",
            ),


          ],
        ),
      ),

      /*End of content*/
    );
  }
}
