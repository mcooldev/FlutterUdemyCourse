import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/pages/favorite_places/place_detail.dart';
import 'package:udemy_course/providers/places_provider.dart';

// import '../../helper/local_db.dart';
import 'add_place.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
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
      builder: (context) => const AddPlace(),
    );
  }

  /// Initialization
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlacesProvider>(context, listen: false).loadPlaces();
    });
    // // Ajoutez temporairement dans initState():
    // LocalDb.instance.clearDatabase();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<PlacesProvider>(
      builder: (_, prov, _) {
        return Scaffold(
          /*
        App bar content here
        */
          appBar: AppBar(title: const Text("Places"), centerTitle: false),

          /*
        FAB content here
        */
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showModalBottomSheet,
            label: Text(
              "Add place",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            icon: const Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
          ),

          /*
        Body content here
        */
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Headline text
                Text(
                  "Available places (${prov.loadedPlaces.length})",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                /// Places list here
                SizedBox(
                  child: prov.loadedPlaces.isEmpty
                      ? const Center(child: Text("No places available"))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: prov.loadedPlaces.length,
                          itemBuilder: (ctx, i) {
                            /// Get place
                            final place = prov.loadedPlaces[i];
                            //
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Dismissible(
                                key: ValueKey(place.id),
                                onDismissed: (direction) {
                                  prov.deletePlace(place);
                                },
                                child: ListTile(
                                  onTap: () {
                                    // todo: add logic to navigate to place detail
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlaceDetail(place: place),
                                      ),
                                    );
                                  },
                                  tileColor: Colors.grey.shade100,
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  leading: Container(
                                    height: 44,
                                    width: 44,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                    ),
                                    child: Image.file(
                                      File(place.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    place.title,
                                    style: Theme.of(context).textTheme.titleLarge!
                                        .copyWith(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    place.address,
                                    style: Theme.of(context).textTheme.bodyLarge!
                                        .copyWith(color: Colors.deepPurpleAccent),
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
        );
      },
    );
  }
}
