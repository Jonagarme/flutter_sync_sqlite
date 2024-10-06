// ignore_for_file: prefer_const_declarations

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_sync/models/user_models.dart';

class DatabaseHelper {
  static const _databaseName = "app_database.db";
  static final int _databaseVersion = 1;
  static final table = 'usuarios';

  static final columnId = 'idUsuario';
  static final columnDocumento = 'documento';
  static final columnNombreCompleto = 'nombreCompleto';
  static final columnCorreo = 'correo';
  static final columnClave = 'clave';
  static final columnIdRol = 'idRol';
  static final columnEstado = 'estado';
  static final columnFechaRegistro = 'fechaRegistro';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDocumento TEXT NOT NULL,
        $columnNombreCompleto TEXT NOT NULL,
        $columnCorreo TEXT NOT NULL,
        $columnClave TEXT NOT NULL,
        $columnIdRol INTEGER NOT NULL,
        $columnEstado INTEGER NOT NULL,
        $columnFechaRegistro TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Usuario usuario) async {
    Database? db = await instance.database;

    // Inserta el usuario y devuelve el ID de la fila insertada
    return await db!.insert('usuarios', usuario.toMap());
  }

  Future<int> deleteUsuario(int id) async {
    Database? db = await instance.database;
    return await db!
        .delete('usuarios', where: 'idUsuario = ?', whereArgs: [id]);
  }

  Future<List<Usuario>> getAllUsuarios() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(table);

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }
}
