import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> register(String username, String password) async {
    final db = await database;
    try {
      await db.insert('users', {'username': username, 'password': password});
    } catch (e) {
      throw Exception('Le nom d\'utilisateur existe déjà.');
    }
  }

  Future<void> login(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = username;
      notifyListeners();
    } else {
      throw Exception('Identifiants incorrects.');
    }
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
