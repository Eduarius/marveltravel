import 'package:mysql1/mysql1.dart';

class Database {
  // Propiedades
  final String _host = 'localhost';
  final int _port = 3306;
  final String _user = 'root';

  // Métodos
  instalacion() async {
    var settings = ConnectionSettings(
      host: this._host, 
      port: this._port,
      user: this._user,
    );
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      await _crearPreguntasMarvel(conn);
      await _CrearTablaPersonajes(conn);
      await conn.close();
    } catch (e) {
      print(e);
      await conn.close();
    }
  }

  Future<MySqlConnection> conexion() async {
    var settings = ConnectionSettings(
      host: this._host, 
      port: this._port,
      user: this._user,
      db: 'marvelTrivial'
    );
      
    return await MySqlConnection.connect(settings);
  }

/////
  Future<void> guardarPuntuacion(int idusuario, int puntuacionNueva) async {
  var conn = await conexion();
  try {
    // Obtener la puntuación actual del usuario
    var result = await conn.query(
      'SELECT puntuacion FROM usuarios WHERE idusuario = ?',
      [idusuario]
    );
    
    // Sumar la puntuación actual con la nueva puntuación
    int puntuacionActual = result.first[0];
    int puntuacionTotal = puntuacionActual + puntuacionNueva;

    // Actualizar la puntuación en la base de datos
    await conn.query(
      'UPDATE usuarios SET puntuacion = ? WHERE idusuario = ?',
      [puntuacionTotal, idusuario]
    );
    
    print('Puntuación guardada correctamente');
  } catch (e) {
    print('Error al guardar la puntuación: $e');
  } finally {
    await conn.close();
  }
}
/////
Future<int> obtenerPuntuacion(int idusuario) async {
  var conn = await Database().conexion();
  try {
    var resultado = await conn.query(
        'SELECT puntuacion FROM usuarios WHERE idusuario = ?',
        [idusuario]);
    if (resultado.isNotEmpty) {
      return resultado.first[0] as int;
    } else {
      print('Error: No se encontró la puntuación del usuario');
      return 0;
    }
  } catch (e) {
    print('Error al obtener la puntuación del usuario: $e');
    return 0;
  } finally {
    await conn.close();
  }
}
////////////////////////////////////

  _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS marvelTrivial');
    await conn.query('USE marvelTrivial');
    print('Conectado a marvelTrivial');
  }

  _crearTablaUsuarios(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS usuarios(
        idusuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(10) NOT NULL,
        puntuacion INT DEFAULT 0
    )''');
    print('Tabla usuarios creada');
  }

  _CrearTablaPersonajes(conn) async {
    await conn.query(''' CREATE TABLE IF NOT EXISTS personajes(
      idpersonaje INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      idusuario INT,
      nombre VARCHAR(100) NOT NULL,
      descripcion VARCHAR(300) NOT NULL,
      habilidad VARCHAR(150) NOT NULL,
      imagen_url VARCHAR(300) NOT NULL,
      puntos_requeridos INT NOT NULL,
      FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario)
    )''');
    print('Tabla personajes creada');
  }

  _crearPreguntasMarvel(conn) async {
    await conn.query(''' CREATE TABLE IF NOT EXISTS preguntas(
      idpregunta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      enunciado VARCHAR(1000) NOT NULL,
      opcion_A VARCHAR(125) NOT NULL,
      opcion_B VARCHAR(125) NOT NULL,
      opcion_C VARCHAR(125) NOT NULL,
      opcion_D VARCHAR(125) NOT NULL,
      respuesta_correcta VARCHAR(225) NOT NULL
    )''');
    print('Tabla preguntas creada');
  }
}
