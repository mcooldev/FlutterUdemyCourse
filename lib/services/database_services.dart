import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:udemy_course/models/shopping.dart';
import 'package:http/http.dart' as http;

class Database {
  /// make class singleton (private constructor)
  Database._();

  static final Database instance = Database._();

  // Post data in database
  final String url = "${dotenv.env["rtdbUrl"]}";

  Future<void> addData(Shopping shoppingItem) async {
    try {
      final uri = Uri.https(url, "shopping.json");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode(shoppingItem.toJsonWithoutId())
      );
      if (response.statusCode == 200) {
        log("🎉✅ • Data added successfully");
      }
    } catch (e) {
      log("Error while posting data: ${e.toString()}");
    }
  }

  // Get data from database (Real time database)
  Future<List<Shopping>> getData() async {
    List<Shopping> shoppingItems = [];
    try {
      final uri = Uri.https(url, "shopping.json");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = convert.jsonDecode(response.body);
        shoppingItems = jsonData.entries.map((entry) {
          Shopping newShoppingItem = Shopping.fromJson(entry.value)
            ..id = entry.key;
          return newShoppingItem;
        }).toList();

        log("🎉✅ • Data retrieved successfully : ${shoppingItems.length})");
      }
    } catch (e) {
      log("Error while retrieving data: ${e.toString()}");
    }
    return shoppingItems;
  }

  // Delete data from database
  Future<void> deleteData(Shopping shoppingItem) async {
    try {
      final uri = Uri.https(url, "shopping/${shoppingItem.id}.json");
      final response = await http.delete(
        uri,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        log("🎉✅ • Data deleted successfully 🗑");
      }
    } catch (e) {
      log("Error while deleting data from database: ${e.toString()}");
    }
  }
}
