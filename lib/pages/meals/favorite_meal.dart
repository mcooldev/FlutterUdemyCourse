import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/meals_provider.dart';
import '../../widgets/meals/meal_item_widget.dart';

class FavoriteMeal extends StatefulWidget {
  const FavoriteMeal({super.key});

  @override
  State<FavoriteMeal> createState() => _FavoriteMealState();
}

class _FavoriteMealState extends State<FavoriteMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(title: const Text("Favorite Meals"), centerTitle: false),

      /*Body content*/
      body: Consumer<MealsProvider>(
        builder: (_, prov, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: prov.favoriteMeals.isEmpty
                ? const Center(child: Text("No favorite meals here"))
                : SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: prov.favoriteMeals.length,
                      itemBuilder: (ctx, index) {
                        final meal = prov.favoriteMeals[index];
                        return MealItemWidget(
                          meal: meal,
                          isFavorite: prov.isMealFavorite(meal.id),
                          onPressFav: () {
                            prov.toggleFavorite(ctx, meal.id);
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
