import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../providers/places_provider.dart';

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  @override
  Widget build(BuildContext context) {
    ///
    final double width = MediaQuery.of(context).size.width;
    final placesProvider = Provider.of<PlacesProvider>(
      context,
      listen: false,
    ); // Ajouter cette ligne

    ///
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.title), centerTitle: false),

      body: Consumer<PlacesProvider>(
        builder: (_, prov, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title place
                Text(
                  widget.place.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),

                /// Location name
                Text(
                  widget.place.address,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 16),

                /// Place image
                  Container(
                    width: width,
                    height: 250,
                    // alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Image.file(File(widget.place.image), fit: BoxFit.cover),
                  ),
                const SizedBox(height: 16),

                /// Location map
                Container(
                  width: width,
                  height: 250,
                  // alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.place.lat, widget.place.lng),
                      zoom: 16.0,
                    ),
                    mapType: MapType.normal,
                    onMapCreated: placesProvider.onMapCreated,
                    markers: {
                      Marker(
                        markerId: const MarkerId("placeId"),
                        position: LatLng(widget.place.lat, widget.place.lng),
                        infoWindow: InfoWindow(
                          title: widget.place.title,
                          snippet: widget.place.address,
                        ),
                      ),
                    },
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
