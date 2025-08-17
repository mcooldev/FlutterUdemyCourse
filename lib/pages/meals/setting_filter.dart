import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/meals_provider.dart';

class SettingFilter extends StatefulWidget {
  const SettingFilter({super.key});

  @override
  State<SettingFilter> createState() => _SettingFilterState();
}

class _SettingFilterState extends State<SettingFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
        App bar content here
      */
      appBar: AppBar(
        title: const Text("Settings filter"),
        centerTitle: false,
        actions: [
          Consumer<MealsProvider>(
            builder: (_, prov, _) {
              final int activeFilterCount = [
                prov.isGlutenFree,
                prov.isLactoseFree,
                prov.isVegan,
                prov.isVegetarian,
              ].where((element) => element == true).length;

              // Active filter states
              Map<String, bool> filterStatesAndName = {
                "Gluten-free": prov.isGlutenFree,
                "Lactose-free": prov.isLactoseFree,
                "Vegan": prov.isVegan,
                "Vegetarian": prov.isVegetarian,
              };

              List<String> filteredTitleAtIndex = filterStatesAndName.entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .toList();

              return TextButton.icon(
                onPressed: activeFilterCount > 0
                    ? () {
                        Navigator.of(context).pushNamed(
                          '/filteredMeals',
                          arguments: filteredTitleAtIndex,
                        );
                        log(filteredTitleAtIndex.toString());
                      }
                    : null,
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: Text(
                  "View results (${activeFilterCount > 0 ? activeFilterCount : ""})",
                ),
              );
            },
          ),
        ],
      ),

      /*
        Body content here
      */
      body: Consumer<MealsProvider>(
        builder: (_, prov, _) {
          return Column(
            children: [
              /// SwitchListTile for Gluten-free
              SwitchListTile(
                value: prov.isGlutenFree,
                onChanged: (val) {
                  prov.setGlutenFree(val);
                },
                title: Text(
                  "Gluten-free",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Only return meals without gluten",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),

              /// SwitchListTile for Lactose-free
              SwitchListTile(
                value: prov.isLactoseFree,
                onChanged: (val) {
                  prov.setLactoseFree(val);
                },
                title: Text(
                  "Lactose-free",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Only return meals without Lactose",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),

              //
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              //

              /// SwitchListTile for Vegetarian
              SwitchListTile(
                value: prov.isVegetarian,
                onChanged: (val) {
                  prov.setVegetarian(val);
                },
                title: Text(
                  "Vegetarian",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Only return meals for Vegetarian",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),

              /// SwitchListTile for Vegan
              SwitchListTile(
                value: prov.isVegan,
                onChanged: (val) {
                  prov.setVegan(val);
                },
                title: Text(
                  "Vegan",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Only return meals for Vegan",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          );
        },
      ),

      /*
        End of body content
      */
    );
  }
}
