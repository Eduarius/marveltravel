import 'package:mysql1/mysql1.dart';
import 'database.dart';

class Personaje {
  int? idpersonaje;
  int?idusuario;
  String? nombre;
  String? descripcion;
  String? habilidad;
  String? imagen_url;
  int? puntos_requeridos;

  // Constructor por defecto
  Personaje();

  // Constructor desde un mapa
  Personaje.fromMap(ResultRow map) {
    this.idpersonaje = map['idpersonaje'];
    this.idusuario= map['idusuario'];
    this.nombre = map['nombre'];
    this.descripcion = map['descripcion'];
    this.habilidad = map['habilidad'];
    this.imagen_url = map['imagen_url'];
    this.puntos_requeridos = map['puntos_requeridos'];
  }
}

// Función para insertar personajes en la base de datos
Future<void> insertarPersonajes() async {
  var conn = await Database().conexion();
  try {
    // Insertar los personajes utilizando sentencias SQL
    await conn.query('''
      INSERT INTO personajes (nombre, descripcion, habilidad, imagen_url, puntos_requeridos)
      VALUES
        ('Spider-Man', 'El Hombre Araña', 'Agilidad y reflejos sobrehumanos', 'https://example.com/spiderman.jpg', 20),
        ('Iron Man', 'El Hombre de Hierro', 'Tecnología avanzada y armadura potenciada', 'https://example.com/ironman.jpg', 25),
        ('Thor', 'Dios del Trueno', 'Control del martillo Mjolnir y control sobre el trueno y los relámpagos', 'https://example.com/thor.jpg', 30),
        ('Hulk', 'El Gigante Esmeralda', 'Fuerza sobrehumana y regeneración', 'https://example.com/hulk.jpg', 35),
        ('Black Widow', 'La Viuda Negra', 'Habilidad en combate cuerpo a cuerpo y maestría en armas', 'https://example.com/blackwidow.jpg', 20)
    ''');
    print('Personajes insertados correctamente');
  } catch (e) {
    print('Error al insertar los personajes: $e');
  } finally {
    await conn.close();
  }
}



void main() async {
  // Llamar a la función para insertar personajes
  await insertarPersonajes();
}
