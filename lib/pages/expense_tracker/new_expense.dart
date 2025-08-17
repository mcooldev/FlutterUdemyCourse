import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/models/expense.dart';
import 'package:udemy_course/providers/expense_provider.dart';
import 'package:udemy_course/widgets/material_btn.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  ///

  ///
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
      builder: (ctx, constraints) {
        ///
        final widthLayout = constraints.maxWidth;

        ///
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<ExpenseProvider>(
            builder: (_, expenseProv, _) {
              final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
              final width = MediaQuery.of(context).size.width;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  width < 600 ? 54.0 : 32,
                  16.0,
                  keyboardPadding + 16,
                ),
                child: Column(
                  children: [
                    /// Headline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "New expense",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xffdcdfe3),
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /*

                    if (widthLayout >= 600)

                    */
                    if (widthLayout >= 600)
                      Column(
                        children: [
                          /// title text field & amount text field here
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// title text field here
                              Expanded(
                                child: TextField(
                                  controller: expenseProv.titleController,
                                  maxLength: 50,
                                  decoration: const InputDecoration(
                                    labelText: "Title",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Amount text field here
                              Expanded(
                                child: TextField(
                                  controller: expenseProv.amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: true,
                                      ),
                                  decoration: const InputDecoration(
                                    prefixText: "\$",
                                    labelText: "Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              //
                            ],
                          ),
                          const SizedBox(height: 24),

                          /// Date picker & category dropdown here
                          Row(
                            children: [
                              /// Date picker here
                              Expanded(
                                child: TextField(
                                  onTap: () {
                                    // todo: add logic to show date picker and save selected date
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2030),
                                    ).then((val) {
                                      setState(() {
                                        expenseProv.selectedDate = val!;
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        "${expenseProv.selectedDate.day}/${expenseProv.selectedDate.month}/${expenseProv.selectedDate.year}",
                                    // labelText: "Date",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Category dropdown here
                              Expanded(
                                child: DropdownButton(
                                  menuMaxHeight: double.infinity,
                                  dropdownColor: Colors.white,
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(10),
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 18,
                                  ),
                                  value: expenseProv.selectedCategory,
                                  hint: const Text("Select category"),
                                  isExpanded: true,
                                  items: Category.values.map((Category e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  onChanged: (Category? val) {
                                    //   todo: add logic to save selected category
                                    setState(() {
                                      expenseProv.selectedCategory = val!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          /// Save button here
                          MaterialBtn(
                            onPressed: () {
                              //   todo: add logic to save expense
                              expenseProv.addExpense();
                              Navigator.of(context).pop();
                            },
                            btnText: "Save",
                          ),
                        ],
                      )
                    /*

                      if (widthLayout < 600)

                      */
                    else
                      Column(
                        children: [
                          /// title text field here
                          TextField(
                            controller: expenseProv.titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              labelText: "Title",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// Amount and date picker
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// amount text field here
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: expenseProv.amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: true,
                                      ),
                                  decoration: const InputDecoration(
                                    prefixText: "\$",
                                    labelText: "Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              /// Date picker here
                              Expanded(
                                child: TextField(
                                  onTap: () {
                                    // todo: add logic to show date picker and save selected date
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2030),
                                    ).then((val) {
                                      setState(() {
                                        expenseProv.selectedDate = val!;
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        "${expenseProv.selectedDate.day}/${expenseProv.selectedDate.month}/${expenseProv.selectedDate.year}",
                                    // labelText: "Date",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          /// Category dropdown & save button
                          Row(
                            children: [
                              /// Category dropdown here
                              Expanded(
                                flex: 2,
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 18,
                                  ),
                                  value: expenseProv.selectedCategory,
                                  hint: const Text("Select category"),
                                  isExpanded: true,
                                  items: Category.values.map((Category e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  onChanged: (Category? val) {
                                    //   todo: add logic to save selected category
                                    setState(() {
                                      expenseProv.selectedCategory = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              /// Save button here
                              Expanded(
                                child: MaterialBtn(
                                  onPressed: () {
                                    //   todo: add logic to save expense
                                    expenseProv.addExpense();
                                    Navigator.of(context).pop();
                                  },
                                  btnText: "Save",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
