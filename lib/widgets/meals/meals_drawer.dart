import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealsDrawer extends StatelessWidget {
  const MealsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurpleAccent.shade100,
                ],
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.set_meal_rounded,
                color: Colors.white,
                size: 44,
              ),
              title: Text(
                "Meals",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),

          /*Drawer items*/

          /// Go to home
          ListTile(
            onTap: () {
              // pop drawer
              Navigator.of(context).pop();

              //
              // todo
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("/", (route) => false);
            },
            leading: const Icon(
              CupertinoIcons.house_alt_fill,
              color: Colors.deepPurpleAccent,
            ),
            title: Text("Home", style: Theme.of(context).textTheme.bodyLarge),
          ),

          /// Go to available meals
          ListTile(
            onTap: () {
              // pop drawer
              Navigator.of(context).pop();

              //
              // todo
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("/mealsCategory", (route) => false);
            },
            leading: const Icon(
              Icons.set_meal_rounded,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "Available meals",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          /// Go to favorite meals
          ListTile(
            onTap: () {
              // pop drawer
              Navigator.of(context).pop();

              //
              Navigator.of(
                context,
              ).pushNamed("/favMeal");
            },
            leading: const Icon(Icons.favorite, color: Colors.deepPurpleAccent),
            title: Text(
              "Favorite meals",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          /// Go to Settings filter
          ListTile(
            onTap: () {
              // pop drawer
              Navigator.of(context).pop();

              //
              Navigator.of(
                context,
              ).pushNamed("/settingFilter");
            },
            leading: const Icon(Icons.settings, color: Colors.deepPurpleAccent),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

        ],
      ),
    );
  }
}
