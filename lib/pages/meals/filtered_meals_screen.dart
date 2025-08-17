import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/meals_provider.dart';
import '../../widgets/meals/meal_item_widget.dart';

class FilteredMealsScreen extends StatefulWidget {
  const FilteredMealsScreen({super.key});

  @override
  State<FilteredMealsScreen> createState() => _FilteredMealsScreenState();
}

class _FilteredMealsScreenState extends State<FilteredMealsScreen> {
  ///
  late List<String> titles;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    titles = ModalRoute.of(context)!.settings.arguments as List<String>;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Meals filtered by",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 4),
            Text(
              titles.join(" • "),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        centerTitle: false,
      ),

      /*Body content*/
      body: Consumer<MealsProvider>(
        builder: (_, prov, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prov.getMealsListBy.length,
                itemBuilder: (ctx, index) {
                  final meal = prov.getMealsListBy[index];
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
