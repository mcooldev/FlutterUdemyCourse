import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/meals_provider.dart';
import 'package:udemy_course/widgets/meals/meals_drawer.dart';

import '../../models/meal.dart';
import '../../widgets/meals/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  ///
  late AnimationController animationController;

  /// Initialization
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    animationController.forward();
  }

  /// Disposer
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(title: const Text("Meals Categories"), centerTitle: false),

      /*Drawer content*/
      drawer: const MealsDrawer(),

      /*Body content*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<MealsProvider>(
          builder: (_, prov, _) {
            return AnimatedBuilder(
              animation: animationController,
              builder: (ctx, child) {
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prov.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3 / 2,
                        ),
                    itemBuilder: (ctx, index) {
                      final category = prov.categories[index];
                      return CategoryWidget(
                        onSelectCategory: () {
                          // todo
                          final String title = category.title;
                          final List<Meal> filterMeals = prov
                              .getMealsByCategory(category);

                          //
                          Navigator.of(context).pushNamed(
                            "/mealsScreen",
                            arguments: {"title": title, "meals": filterMeals},
                          );
                        },
                        category: category,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),

      /*End of content*/
    );
  }
}
