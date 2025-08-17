import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  /// Expenses list
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Course',
      amount: 24.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Flight ticket to Italy',
      amount: 75.79,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  List<Expense> get expenses => [..._expenses];

  ///
  DateTime selectedDate = DateTime.now();
  Category? selectedCategory;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void addExpense() {
    final newExpense = Expense(
      title: titleController.text,
      amount: double.parse(amountController.text),
      date: selectedDate,
      category: selectedCategory!,
    );
    _expenses.insert(0, newExpense);
    //
    titleController.clear();
    amountController.clear();
    selectedDate = DateTime.now();
    selectedCategory = null;
    notifyListeners();
  }

  /// Delete expense
  void deleteExpense(BuildContext context, Expense expense) {
    final expenseIndex = _expenses.indexOf(expense);
    _expenses.removeAt(expenseIndex);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense removed successfuly"),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            _expenses.insert(expenseIndex, expense);
            notifyListeners();
          },
        ),
      ),
    );
    notifyListeners();
  }

  /// Sort expenses by name
  String _order = "asc";
  String _sortBy = "date";
  bool _isSorted = false;

  String get order => _order;

  String get sortBy => _sortBy;

  bool get isSorted => _isSorted;

  List<Expense> get sortedExpenses {
    if (_expenses.isEmpty) return [];
    final List<Expense> sortedList = [..._expenses];
    if (_isSorted) {
      switch (_sortBy) {
        case "date":
          sortedList.sort((a, b) {
            final compare = a.date.compareTo(b.date);
            return _order == "asc" ? compare : -compare;
          });
          break;
        case "amount":
          sortedList.sort((a, b) {
            final compare = a.amount.compareTo(b.amount);
            return _order == "asc" ? compare : -compare;
          });
          break;
        case "name":
          sortedList.sort((a, b) {
            final compare = a.title.compareTo(b.title);
            return _order == "asc" ? compare : -compare;
          });
          break;
        case "category":
          sortedList.sort((a, b) {
            final compare = a.category.name.compareTo(b.category.name);
            return _order == "asc" ? compare : -compare;
          });
          break;
        default:
          sortedList.sort((a, b) {
            final compare = a.date.compareTo(b.date);
            return _order == "asc" ? compare : -compare;
          });
          break;
      }
    }
    return sortedList;
  }

  /// Sort by name
  void sortByName() {
    if (_sortBy == "name" && _isSorted) {
      _order = _order == "asc" ? "desc" : "asc";
    } else {
      _order = "asc";
      _sortBy = "name";
      _isSorted = true;
    }
    notifyListeners();
  }

  /// Sort by date
  void sortByDate() {
    if (_sortBy == "date" && _isSorted) {
      _order = _order == "asc" ? "desc" : "asc";
    } else {
      _order = "asc";
      _sortBy = "date";
      _isSorted = true;
    }
    notifyListeners();
  }

  /// Sort by amount
  void sortByAmount() {
    if (_sortBy == "amount" && _isSorted) {
      _order = _order == "asc" ? "desc" : "asc";
    } else {
      _order = "asc";
      _sortBy = "amount";
      _isSorted = true;
    }
    notifyListeners();
  }

  /// Sort by category
  void sortByCategory() {
    if (_sortBy == "category" && _isSorted) {
      _order = _order == "asc" ? "desc" : "asc";
    } else {
      _order = "asc";
      _sortBy = "category";
      _isSorted = true;
    }
    notifyListeners();
  }

  ///
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
