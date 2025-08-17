// import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/place.dart';

class LocalDb {
  /// Singleton instance
  LocalDb._();

  static final LocalDb instance = LocalDb._();

  /// Database instance
  Database? db;

  /// Get the database
  Future<Database> getDatabase() async {
    if (db != null) return db!;
    return db = await initDatabase();
  }

  /// Initialize the database
  Future<Database> initDatabase() async {
    //
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "places.db");

    //
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return await db.execute('''
          CREATE TABLE places(
          id TEXT PRIMARY KEY, 
          title TEXT, 
          image TEXT, 
          lat REAL, 
          lng REAL, 
          address TEXT)
          ''');
      },
    );
  }

  /// Insert a new place
  Future<int> insert(Place place) async {
    final db = await getDatabase();
    return await db.insert("places", place.toJson());
  }

  /// Get all places
  Future<List<Place>> getPlaces() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> fetchedPlaces = await db.query("places");

    //
    if (fetchedPlaces.isEmpty) return [];
    return fetchedPlaces.map((e) => Place.fromJson(e)).toList();
  }

  /// Delete all places
  Future<int> deleteData(Place place) async {
    final db = await getDatabase();
    return await db.delete("places", where: "id = ?", whereArgs: [place.id]);
  }

  ///


  // /// 🔥 NOUVELLE MÉTHODE : Clear database completely
  // Future<void> clearDatabase() async {
  //   try {
  //     // Fermer la connexion existante
  //     if (db != null) {
  //       await db!.close();
  //       db = null;
  //     }
  //
  //     // Supprimer le fichier de base de données
  //     final dbPath = await getDatabasesPath();
  //     final path = join(dbPath, "places.db");
  //
  //     final file = File(path);
  //     if (await file.exists()) {
  //       await file.delete();
  //       print('✅ Base de données supprimée avec succès');
  //     }
  //
  //   } catch (e) {
  //     print('❌ Erreur lors de la suppression: $e');
  //   }
  // }
}
