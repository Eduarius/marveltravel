import 'package:mysql1/mysql1.dart';
import 'database.dart';

class Usuario {
  // Propiedades
  int?idusuario;
  String?nombre;
  String?password;
  int?puntuacion;

  // Constructores
  Usuario();

  Usuario.fromMap(ResultRow map) {
    this.idusuario = map['idusuario'];
    this.nombre = map['nombre'];
    this.password = map['password'];
    this.puntuacion = map['puntuacion'];
  }

  // Método para crear un nuevo usuario
  loginUsuario() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query('SELECT * FROM usuarios WHERE nombre = ?', [nombre]);
      if (resultado.isNotEmpty) {
        Usuario usuario = Usuario.fromMap(resultado.first);
        if (password == usuario.password) {
          // Establecer el ID de usuario en el objeto Usuario
          idusuario = usuario.idusuario;
          return usuario;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      await conn.close();
    }
  }


  insertarUsuario() async {
    var conn = await Database().conexion();
    try {
      await conn.query('INSERT INTO usuarios (nombre, password) VALUES (?,?)',
          [nombre, password]);
      print('Usuario insertado correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

}

