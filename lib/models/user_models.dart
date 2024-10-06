class Usuario {
  int? idUsuario;
  String documento;
  String nombreCompleto;
  String correo;
  String clave;
  int idRol;
  bool estado;
  DateTime fechaRegistro;

  Usuario({
    this.idUsuario, // Deja que el idUsuario sea opcional
    required this.documento,
    required this.nombreCompleto,
    required this.correo,
    required this.clave,
    required this.idRol,
    required this.estado,
    required this.fechaRegistro,
  });

  // Convertir a mapa para insertar en SQLite
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'documento': documento,
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'clave': clave,
      'idRol': idRol,
      'estado': estado ? 1 : 0,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };

    // Solo incluir idUsuario si no es null
    if (idUsuario != null) {
      map['idUsuario'] = idUsuario;
    }
    return map;
  }

  // Convertir desde un mapa (de SQLite)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      documento: map['documento'],
      nombreCompleto: map['nombreCompleto'],
      correo: map['correo'],
      clave: map['clave'],
      idRol: map['idRol'],
      estado: map['estado'] == 1,
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }
}
