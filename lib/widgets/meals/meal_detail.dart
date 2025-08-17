import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/meal.dart';
import '../../providers/meals_provider.dart';

class MealDetail extends StatefulWidget {
  const MealDetail({super.key});

  @override
  State<MealDetail> createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  ///
  late String mealId;
  late Meal meal;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    mealId = ModalRoute.of(context)!.settings.arguments as String;
    meal = Provider.of<MealsProvider>(context).getMealById(mealId);
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final provMeal = context.read<MealsProvider>();

    ///
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(title: const Text("Meal Detail"), centerTitle: false),

      /*Body content*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Meal image here
            Stack(
              fit: StackFit.loose,
              children: [
                Hero(tag: meal.id, child: Image.network(meal.imageUrl)),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      provMeal.toggleToFav(context, meal);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: provMeal.isFavorite(meal)
                            ? Colors.red
                            : Colors.white,
                        size: 30,
                        key: ValueKey(provMeal.isFavorite(meal)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            ///
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Meal title here
                  Text(
                    meal.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),

                  /// Meal duration & Affordability & Complexity here
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xfff2f4f7),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Duration
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Cooking time",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 20,
                                  color: Colors.deepPurpleAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${meal.duration} min",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Text("•"),
                        const SizedBox(width: 4),

                        /// Affordability
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Affordability",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.sparkles,
                                  color: Colors.deepPurpleAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  meal.affordability.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Text("•"),
                        const SizedBox(width: 4),

                        /// Complexity
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Complexity",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.back_hand_outlined,
                                  color: Colors.deepPurpleAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  meal.complexity.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Gluten, lactose, vegan, vegetarian here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Gluten & Lactose
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xfff2f4f7),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Gluten
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Gluten-free",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (meal.isGlutenFree)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 20,
                                          color: Colors.green,
                                        )
                                      else
                                        const Icon(
                                          Icons.unpublished_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      const SizedBox(width: 4),
                                      Text(
                                        meal.isGlutenFree ? "Yes" : "No",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              const Text("•"),
                              const SizedBox(width: 4),

                              /// Lactose
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Lactose-free",
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        if (meal.isLactoseFree)
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            size: 20,
                                            color: Colors.green,
                                          )
                                        else
                                          const Icon(
                                            Icons.unpublished_rounded,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        const SizedBox(width: 4),
                                        Text(
                                          meal.isLactoseFree ? "Yes" : "No",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      /// Vegan & Vegetarian
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xfff2f4f7),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Vegetarian
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Vegetarian",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (meal.isVegetarian)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 20,
                                          color: Colors.green,
                                        )
                                      else
                                        const Icon(
                                          Icons.unpublished_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      const SizedBox(width: 4),
                                      Text(
                                        meal.isVegetarian ? "Yes" : "No",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              const Text("•"),
                              const SizedBox(width: 4),

                              /// Vegan
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Vegan",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (meal.isVegan)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 20,
                                          color: Colors.green,
                                        )
                                      else
                                        const Icon(
                                          Icons.unpublished_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      const SizedBox(width: 4),
                                      Text(
                                        meal.isVegan ? "Yes" : "No",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Meal ingredients & Steps here
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: ShapeDecoration(
                      color: const Color(0xfff2f4f7),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Ingredients (${meal.ingredients.length})",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Ingredients container here
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: List.generate(meal.ingredients.length, (
                              i,
                            ) {
                              final ingredients = meal.ingredients[i];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xffdcdfe3),
                                  ),
                                ),
                                child: Text(ingredients),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Steps
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Steps (${meal.steps.length})",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Steps container here
                        Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (ctx, i) => const Divider(
                              thickness: 2,
                              color: Color(0xfff2f4f7),
                            ),

                            itemCount: meal.steps.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xfff2f4f7),
                                  child: Text(
                                    "${i + 1}",
                                    style: const TextStyle(
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  meal.steps[i],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
