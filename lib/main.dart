import 'dart:async'; // Necesario para StreamSubscription
import 'package:flutter/material.dart';
import 'package:sqlite_sync/database/database_helper.dart';
import 'package:sqlite_sync/models/user_models.dart';
import 'package:sqlite_sync/utils/sync_server.dart';
import 'package:sqlite_sync/widgets/user_form.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Para monitorear la conectividad

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuario Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Usuario> _usuarios = [];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadUsuarios();

    // Monitorear cambios en la conexión a internet
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // Llamar al método para sincronizar cuando se detecta conexión
        syncWithServer();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // Cancelar la suscripción al monitoreo de la conectividad
    super.dispose();
  }

  // Método para cargar usuarios desde la base de datos
  Future<void> _loadUsuarios() async {
    List<Usuario> usuarios = await DatabaseHelper.instance.getAllUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  // Método para eliminar un usuario de la base de datos
  Future<void> _deleteUsuario(int id) async {
    await DatabaseHelper.instance.deleteUsuario(id);
    _loadUsuarios(); // Recargar la lista después de eliminar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text('Agregar Usuario'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsuarioForm()),
              );
              _loadUsuarios();
            },
          ),
          Expanded(
            child: _usuarios.isEmpty
                ? const Center(child: Text('No hay usuarios creados.'))
                : ListView.builder(
                    itemCount: _usuarios.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_usuarios[index].nombreCompleto),
                        subtitle: Text(_usuarios[index].correo),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (_usuarios[index].idUsuario != null) {
                              _deleteUsuario(_usuarios[index].idUsuario!);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
