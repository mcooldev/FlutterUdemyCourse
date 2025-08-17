import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/meals_provider.dart';

import '../../models/meal.dart';
import '../../widgets/meals/meal_item_widget.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  ///
  late String title;

  late List<Meal> meals;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    title = routeArgs['title'];
    meals = routeArgs['meals'] as List<Meal>;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(title: Text(title), centerTitle: false),

      /*Body content*/
      body: Consumer<MealsProvider>(
        builder: (_, prov, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: meals.isEmpty
                ? const Center(child: Text("No meals here"))
                : SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (ctx, index) {
                        final meal = meals[index];
                        return MealItemWidget(
                          meal: meal,
                          isFavorite: prov.isFavorite(meal),
                          onPressFav: () {
                            prov.toggleToFav(ctx, meal);
                          },
                          onTapMeal: () {
                            // Get meal id
                            final mealId = meal.id;

                            //
                            Navigator.of(
                              context,
                            ).pushNamed('/mealDetail', arguments: mealId);
                          },
                        );
                      },
                    ),
                  ),
          );
        },
      ),

      /*End of content*/
    );
  }
}
