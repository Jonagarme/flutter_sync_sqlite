// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqlite_sync/database/database_helper.dart';
import 'package:sqlite_sync/models/user_models.dart';

class UsuarioForm extends StatefulWidget {
  @override
  _UsuarioFormState createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final _documentoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _idRolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _documentoController,
                decoration: const InputDecoration(labelText: 'Documento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el documento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre completo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _claveController,
                decoration: const InputDecoration(labelText: 'Clave'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la clave';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idRolController,
                decoration: const InputDecoration(labelText: 'Rol ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el ID del rol';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Usuario usuario = Usuario(
                      idUsuario:
                          null, // Deja que SQLite maneje el autoincremento
                      documento: _documentoController.text,
                      nombreCompleto: _nombreController.text,
                      correo: _correoController.text,
                      clave: _claveController.text,
                      idRol: int.parse(_idRolController.text),
                      estado: true,
                      fechaRegistro: DateTime.now(),
                    );

                    try {
                      // Intentar insertar el usuario en la base de datos
                      int result =
                          await DatabaseHelper.instance.insert(usuario);

                      // Verifica si la inserción fue exitosa
                      if (result > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuario guardado localmente')));
                        Navigator.pop(
                            context); // Regresar a la pantalla anterior
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Error al guardar el usuario')));
                      }
                    } catch (e) {
                      // Si hay algún error, muéstralo en el mensaje
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Guardar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
