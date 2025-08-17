import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/pages/expense_tracker/new_expense.dart';
import 'package:udemy_course/providers/expense_provider.dart';
import 'package:udemy_course/widgets/chartWidgets/chart.dart';

import '../../models/expense.dart';

class ExpenseDashboard extends StatefulWidget {
  const ExpenseDashboard({super.key});

  @override
  State<ExpenseDashboard> createState() => _ExpenseDashboardState();
}

class _ExpenseDashboardState extends State<ExpenseDashboard> {
  ///

  ///
  void _showModalBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      constraints: const BoxConstraints.expand(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (ctx) => const NewExpense(),
    );
  }

  /// initialize
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).sortedExpenses;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    ///
    return Scaffold(
      /*App bar content*/
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: false,
        // actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: _showModalBottomSheet,
            icon: const Icon(Icons.add, color: Colors.deepPurpleAccent),
          ),
        ],
      ),

      /*Body content*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ExpenseProvider>(
          builder: (_, prov, _) {
            return prov.sortedExpenses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("No expense available !")],
                    ),
                  )
                : width < 600
                /// if (width < 600)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Expenses chart
                      Text(
                        "Expenses stats",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),

                      /// Chart here
                      Chart(expenses: prov.sortedExpenses),

                      const SizedBox(height: 24),

                      /// Expenses title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "My expenses",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${prov.sortedExpenses.length})",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          //
                          ///
                          GestureDetector(
                            onTap: () {
                              // todo: add logic to sort expenses
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Sort by",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 12),
                                        ListTile(
                                          onTap: () {
                                            prov.sortByName();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(
                                            Icons.sort_by_alpha,
                                          ),
                                          title: const Text("Name"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            prov.sortByDate();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(Icons.date_range),
                                          title: const Text("Date"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            prov.sortByAmount();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(
                                            Icons.attach_money,
                                          ),
                                          title: const Text("Amount"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            prov.sortByCategory();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(Icons.category),
                                          title: const Text("Category"),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 44,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xffdcdfe3),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Sort",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.apply(color: Colors.deepPurpleAccent),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.sort,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// Expense list
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: prov.sortedExpenses.length,
                          itemBuilder: (ctx, i) {
                            final expense = prov.sortedExpenses[i];
                            return Dismissible(
                              key: ValueKey(prov.sortedExpenses[i]),
                              onDismissed: (direction) {
                                prov.deleteExpense(ctx, prov.sortedExpenses[i]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade100,
                                    radius: 24,
                                    child: Icon(
                                      categoryIcons[expense.category],
                                      color: Colors.deepPurpleAccent,
                                      size: 22,
                                    ),
                                  ),
                                  title: Text(expense.title),
                                  subtitle: Text(
                                    expense.date.toString().split(" ")[0],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        expense.category.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${expense.amount}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                /// else
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Chart here
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /// Chart title
                            Text(
                              "Expenses stats",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 24),

                            /// Chart here
                            Chart(expenses: prov.expenses),
                          ],
                        ),
                      ),

                      /// Expense list here
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Expenses title
                            Row(
                              children: [
                                Text(
                                  "My expenses",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${prov.expenses.length})",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// Expense list
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: prov.expenses.length,
                                itemBuilder: (ctx, i) {
                                  final expense = prov.expenses[i];
                                  return Dismissible(
                                    key: ValueKey(prov.expenses[i]),
                                    onDismissed: (direction) {
                                      prov.deleteExpense(ctx, prov.expenses[i]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: ListTile(
                                        shape: ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          side: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey.shade100,
                                          radius: 24,
                                          child: Icon(
                                            categoryIcons[expense.category],
                                            color: Colors.deepPurpleAccent,
                                            size: 22,
                                          ),
                                        ),
                                        title: Text(expense.title),
                                        subtitle: Text(
                                          expense.date.toString().split(" ")[0],
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              expense.category.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "\$${expense.amount}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),

      /*End of content*/
      /**/
    );
  }
}
