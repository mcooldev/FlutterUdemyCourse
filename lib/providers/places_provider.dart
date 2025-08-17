import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../helper/local_db.dart';
import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  // final List<Place> _places = [];
  //
  // List<Place> get places => [..._places];

  final titleController = TextEditingController();
  GoogleMapController? mapController;

  // Get local database instance
  final LocalDb db = LocalDb.instance;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  /// Load places from database
  final List<Place> _loadedPlaces = [];

  List<Place> get loadedPlaces => [..._loadedPlaces];

  Future<void> loadPlaces() async {
    final places = await db.getPlaces();
    _loadedPlaces.clear();
    _loadedPlaces.addAll(places);
    notifyListeners();
  }

  // Add place && Delete place
  void addPlace() async {
    String newLocation = locationName();
    String newTitle = titleController.text;

    //
    if (_image == null ||
        newLocation.isEmpty ||
        titleController.text.isEmpty ||
        latLng == null) {
      log("Cannot add place: missing data or coordinates");
      return;
    }

    //
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(_image!.path);
    final savedImage = await _image!.copy('${appDir.path}/$fileName');
    final imageString = savedImage.path;

    final place = Place(
      title: newTitle,
      image: imageString,
      lat: latLng!.latitude,
      lng: latLng!.longitude,
      address: newLocation,
    );

    //
    // _places.add(place);
    _loadedPlaces.add(place);

    // Add place to database
    db.insert(place);

    // Clear necessary fields
    titleController.clear();
    currentLocation = null;
    latLng = null;
    _image = null;
    // Notify listeners
    notifyListeners();
  }

  // Delete place
  void deletePlace(Place place) async {
    final placeIndex = _loadedPlaces.indexWhere((p) => p.id == place.id);
    try {
      if (placeIndex != -1) {
        final removedPlace = _loadedPlaces.removeAt(placeIndex);
        notifyListeners();
        await db.deleteData(removedPlace);
        log("Place deleted successfully");
        notifyListeners();
      }
    } catch (e) {
      log("Error while deleting place: ${e.toString()}");
    }
  }

  // Add image
  File? _image;

  File? get image => _image;

  Future addImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePath = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imagePath == null) return;
    _image = File(imagePath.path);
    notifyListeners();
  }

  /// Get user location
  String? currentLocation;

  // Get place name
  String? placeName() {
    if (currentLocation != null && titleController.text.isEmpty) {
      return currentLocation;
    } else if (currentLocation == null && titleController.text.isNotEmpty) {
      return titleController.text;
    } else {
      return "Enter title or get location";
    }
  }

  // Get location name
  String locationName() {
    if (currentLocation != null) {
      return currentLocation!;
    }
    return "Current location not retrieved";
  }

  // Location LatLong
  LatLng? latLng;

  // Fetch user location for the button
  Future<void> fetchUserLocation() async {
    try {
      final String? location = await getUserLocation();
      if (location != null) {
        currentLocation = location;
        log("Current location: $currentLocation");
        notifyListeners();
      }
    } catch (e) {
      log("Error while fetching user location: ${e.toString()}");
    }
  }

  Future<String?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }
      final locationData = await Geolocator.getCurrentPosition();
      latLng = LatLng(locationData.latitude, locationData.longitude);

      //
      List<gc.Placemark> placemarks = await gc.placemarkFromCoordinates(
        locationData.latitude,
        locationData.longitude,
      );

      if (placemarks.isNotEmpty) {
        final fetchedLocation =
            placemarks[0].subAdministrativeArea ??
            placemarks[0].locality ??
            placemarks[0].administrativeArea ??
            "Unknown location";
        currentLocation = fetchedLocation;
        notifyListeners();
        return currentLocation;
      }
    } catch (e) {
      log("Error while getting user location: ${e.toString()}");
    }
    return null;
  }

  /// Disposer
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }
}
