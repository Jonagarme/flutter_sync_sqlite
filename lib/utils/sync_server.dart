// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite_sync/database/database_helper.dart';
import 'dart:convert';
import 'package:sqlite_sync/models/user_models.dart';

Future<void> syncWithServer() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    List<Usuario> usuarios = await DatabaseHelper.instance.getAllUsuarios();

    for (var usuario in usuarios) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toMap()),
      );

      if (response.statusCode == 200) {
        print('Usuario sincronizado correctamente: ${usuario.nombreCompleto}');

        // Eliminar el usuario de SQLite si se sincroniza correctamente
        if (usuario.idUsuario != null) {
          await DatabaseHelper.instance.deleteUsuario(usuario.idUsuario!);
        }
        print('Usuario ${usuario.nombreCompleto} eliminado localmente.');
      } else {
        print('Error al sincronizar usuario: ${usuario.nombreCompleto}');
      }
    }
  }
}
