import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/shopping.dart';
import '../services/database_services.dart';

class ShoppingProvider with ChangeNotifier {
  /// Grocery items
  final List<Shopping> _groceryItems = [
    Shopping(
      id: 'a',
      name: 'Milk',
      qty: 1,
      category: _categories[Categories.dairy]!,
    ),
    Shopping(
      id: 'b',
      name: 'Bananas',
      qty: 5,
      category: _categories[Categories.fruit]!,
    ),
    Shopping(
      id: 'c',
      name: 'Beef Steak',
      qty: 1,
      category: _categories[Categories.meat]!,
    ),
  ];

  List<Shopping> get groceryItems => [..._groceryItems];

  /// Categories list
  static final Map<Categories, Category> _categories = {
    Categories.vegetables: Category(
      'Vegetables',
      const Color.fromARGB(255, 0, 255, 128),
    ),
    Categories.fruit: Category('Fruit', const Color.fromARGB(255, 145, 255, 0)),
    Categories.meat: Category('Meat', const Color.fromARGB(255, 255, 102, 0)),
    Categories.dairy: Category('Dairy', const Color.fromARGB(255, 0, 208, 255)),
    Categories.carbs: Category('Carbs', const Color.fromARGB(255, 0, 60, 255)),
    Categories.sweets: Category(
      'Sweets',
      const Color.fromARGB(255, 255, 149, 0),
    ),
    Categories.spices: Category(
      'Spices',
      const Color.fromARGB(255, 255, 187, 0),
    ),
    Categories.convenience: Category(
      'Convenience',
      const Color.fromARGB(255, 191, 0, 255),
    ),
    Categories.hygiene: Category(
      'Hygiene',
      const Color.fromARGB(255, 149, 0, 255),
    ),
    Categories.other: Category('Other', const Color.fromARGB(255, 0, 225, 255)),
  };

  Map<Categories, Category> get categories => {..._categories};

  /// Add grocery item
  String selectedCategory = "Select a category";

  Category? selectedCategoryObject;

  void onChanged(Category? value) {
    selectedCategoryObject = value;
    notifyListeners();
  }

  ///
  final nameController = TextEditingController();
  final qtyController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  /// Data from database(Firebase real time database)
  final Database db = Database.instance;
  List<Shopping> _shoppingItems = [];

  List<Shopping> get shoppingItems => [..._shoppingItems];

  Future<List<Shopping>> getShoppingItems() async {
    try {
      _shoppingItems = await db.getData();
      _shoppingItems.sort((a, b) => -a.id.compareTo(b.id));
      notifyListeners();
    } catch (e) {
      log("Error while getting data: ${e.toString()}");
      _shoppingItems = [];
    }
    return _shoppingItems;
  }

  void onValidate(BuildContext context) {
    if (formKey.currentState!.validate()) {
      //
      Shopping shoppingItem = Shopping(
        id: DateTime.now().toString(),
        name: nameController.text,
        qty: int.parse(qtyController.text),
        category: selectedCategoryObject!,
      );
      _shoppingItems.insert(0, shoppingItem);
      //
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉✅ • Item added successfully"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      /// Add to Firebase real time database
      Shopping shoppingItemWithoutId = shoppingItem.copyWith(
        name: shoppingItem.name,
        qty: shoppingItem.qty,
        category: shoppingItem.category,
      );
      db.addData(shoppingItemWithoutId);

      //
      Navigator.of(context).pop();
      //
      nameController.clear();
      qtyController.clear();
      selectedCategory = "Select a category";
      selectedCategoryObject = null;
      //
      notifyListeners();
    }
  }

  /// Delete grocery item
  void deleteGroceryItem(BuildContext context, Shopping shoppingItem) async {
    try {
      final int itemIndex = _shoppingItems.indexWhere((item) => item.id == shoppingItem.id);
      _shoppingItems.removeAt(itemIndex);
      await db.deleteData(shoppingItem);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉✅ • Item successfully deleted 🗑"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      log("Error while deleting data: ${e.toString()}");
    }
  }

  ///
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    qtyController.dispose();
    super.dispose();
  }
}
