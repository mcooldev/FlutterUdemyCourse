import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/providers/shopping_provider.dart';

import '../../widgets/shoppingWidgets/new_item.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShoppingProvider>(context, listen: false).getShoppingItems();
    });
  }


  ///
  @override
  Widget build(BuildContext context) {
    ///
    final shopProv = Provider.of<ShoppingProvider>(context);

    ///
    return Scaffold(
      /*
      App bar content
      */
      appBar: AppBar(
        title: const Text("Shopping"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  return const NewItem();
                },
              );
            },
            icon: Row(
              children: [
                Text(
                  "Add",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ],
      ),

      /*
      Body content
      */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available products (${shopProv.shoppingItems.length})",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              child: Consumer<ShoppingProvider>(
                builder: (_, prov, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prov.shoppingItems.length,
                    itemBuilder: (ctx, i) {
                      final item = prov.shoppingItems[i];
                      return Dismissible(
                        key: ValueKey(item.id),
                        onDismissed: (_) {
                          prov.deleteGroceryItem(context, item);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: item.category.color,
                            radius: 20,
                          ),
                          title: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            item.category.title,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: Colors.deepPurpleAccent),
                          ),
                          trailing: Text(
                            item.qty.toString().padLeft(2, "0"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
