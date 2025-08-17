import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.image,
    required this.lat,
    required this.lng,
    required this.address,
    String? id,
  }) : id = uuid.v4();
  final String id;
  final String title;
  final String image;
  double lat;
  double lng;
  String address;

  //
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      lat: json['lat'] ?? 0.0,
      lng: json['lng'] ?? 0.0,
      address: json['address'] ?? '',
    );
  }

  //
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }
}
