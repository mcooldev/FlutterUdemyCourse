import 'package:flutter/material.dart';

import '../../models/meal.dart';

class MealItemWidget extends StatelessWidget {
  const MealItemWidget({
    super.key,
    required this.meal,
    this.isFavorite = false,
    required this.onTapMeal,
    required this.onPressFav,
  });

  final Meal meal;
  final bool isFavorite;
  final void Function()? onTapMeal;
  final void Function()? onPressFav;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapMeal,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(6.0),
        decoration: ShapeDecoration(
          color: const Color(0xfff2f4f7),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            /// Image container
            Stack(
              fit: StackFit.loose,
              children: [
                Hero(
                  tag: meal.id,
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      color: const Color(0xfff2f4f7),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Image.network(meal.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: onPressFav,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 30,
                        key: ValueKey(isFavorite),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            ///
            Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.sizeOf(context).width,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Meal category
                  Wrap(
                    runSpacing: 8,
                    children: List.generate(meal.categories.length, (i) {
                      final category = meal.categories[i];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
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
                        child: Text("Category: $category"),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  /// Meal title
                  Text(
                    meal.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Divider(thickness: 1, color: Color(0xffdcdfe3)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cooking time :",
                        style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
