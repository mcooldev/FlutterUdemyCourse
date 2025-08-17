import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

///
const uuid = Uuid();

///
enum Category { food, travel, leisure, work }

///
final categoryIcons = {
  Category.food: CupertinoIcons.shopping_cart,
  Category.travel: CupertinoIcons.paperplane,
  Category.leisure: CupertinoIcons.sparkles,
  Category.work: CupertinoIcons.briefcase,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  // Alternative constructor
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  // Normal constructor
  ExpenseBucket({required this.category, required this.expenses});

  // Get total expenses
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount.roundToDouble();
    }
    return sum;
  }
}
