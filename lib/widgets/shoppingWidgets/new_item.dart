import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/shopping_provider.dart';

import '../material_btn.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Consumer<ShoppingProvider>(
          builder: (_, shopProv, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 54),

                  /// Headline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "New grocery item",
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

                  Form(
                    key: shopProv.formKey,
                    child: Column(
                      children: [
                        /// Name text form field
                        TextFormField(
                          controller: shopProv.nameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please a name is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Grocery name here",
                            labelText: "Name",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.food_bank_outlined)
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Category dropdown
                        Row(
                          children: [
                            /// Category dropdown
                            Expanded(
                              child: DropdownButton(
                                hint: Text(shopProv.selectedCategory),
                                value: shopProv.selectedCategoryObject,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                                isExpanded: true,
                                onChanged: shopProv.onChanged,
                                items: shopProv.categories.entries
                                    .map(
                                      (entry) => DropdownMenuItem(
                                        value: entry.value,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  entry.value.color,
                                              radius: 10,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(entry.value.title),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// Quantity text form field
                            Expanded(
                              child: TextFormField(
                                controller: shopProv.qtyController,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter a quantity";
                                  }
                                  return null;
                                },
                                keyboardType: const TextInputType.numberWithOptions(
                                  signed: false,
                                  decimal: false,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Quantity",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.numbers_rounded)
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Save button
                        MaterialBtn(
                          onPressed: () {
                            // todo: add logic to save item
                            shopProv.onValidate(context);

                            //
                            Navigator.of(context).pop;
                          },
                          btnText: "Save item",
                        ),
                        const SizedBox(height: 8),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
