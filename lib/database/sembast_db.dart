import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SembastDB {
  static final SembastDB _instance = SembastDB._internal();
  factory SembastDB() => _instance;
  SembastDB._internal();

  Database? _db;

  final StoreRef<int, Map<String, dynamic>> userStore =
      intMapStoreFactory.store('users');

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) {
      return await databaseFactoryWeb.openDatabase('app_web.db');
    }

    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'app.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> register(String username, String password) async {
    final db = await database;

    final existing = await userStore.find(
      db,
      finder: Finder(
        filter: Filter.equals('username', username),
      ),
    );

    if (existing.isNotEmpty) {
      throw Exception('Username already exists');
    }

    await userStore.add(db, {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> login(
      String username, String password) async {
    final db = await database;

    final record = await userStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('username', username),
          Filter.equals('password', password),
        ]),
      ),
    );

    return record?.value;
  }
}