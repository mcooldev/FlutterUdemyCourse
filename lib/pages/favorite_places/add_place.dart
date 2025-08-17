import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/places_provider.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  @override
  Widget build(BuildContext context) {
    ///
    final double width = MediaQuery.of(context).size.width;

    ///
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<PlacesProvider>(
        builder: (_, prov, _) {
          final newTitle = prov.locationName();
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 54, 16, 16),
            child: Column(
              children: [
                /// Headline
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "New Place",
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
                const SizedBox(height: 16),

                /// title text field here
                TextField(
                  controller: prov.titleController,
                  // maxLength: 50,
                  decoration: InputDecoration(
                    focusColor: Colors.deepPurpleAccent,
                    labelText: "Title",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                /// Get user location button here
                MaterialButton(
                  onPressed: () async {
                    // todo: add logic to fetch user location
                    await prov.fetchUserLocation();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                    side: BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  minWidth: double.infinity,
                  child: Text(
                    "Get user location 📍",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  newTitle.isEmpty ? "No location selected" : newTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 24),

                /// image button here
                Container(
                  width: width,
                  height: 250,
                  // alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  decoration: prov.image == null
                      ? ShapeDecoration(
                          color: Colors.grey.shade100,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        )
                      : ShapeDecoration(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                  child: prov.image != null
                      ? Image.file(prov.image!, fit: BoxFit.cover)
                      : IconButton(
                          onPressed: () {
                            // todo: add logic to open camera
                            prov.addImage();
                          },
                          icon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.camera_on_rectangle,
                                color: Colors.black12,
                                size: 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Add image",
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: Colors.black45,
                                      fontSize: 18,
                                    ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                /// Save button here
                MaterialButton(
                  onPressed: () {
                    // todo: add logic to save place
                    prov.addPlace();
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                    side: BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                  color: Colors.deepPurpleAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  minWidth: double.infinity,
                  child: Text(
                    "Save Place",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
