import 'package:mysql1/mysql1.dart';
import 'database.dart';

class JuegoTrivial {
  Future<void> insertarPreguntaConOpciones(PreguntaConOpciones pregunta) async {
    var conn = await Database().conexion();
    try {
      // Verificar si la pregunta ya existe en la base de datos
      var resultado = await conn.query(
        'SELECT COUNT(*) AS total FROM preguntas WHERE enunciado = ?',
        [pregunta.enunciado],
      );

      var total = resultado.first['total'] ?? 0;
      if (total == 0) {
        // La pregunta no existe, entonces la insertamos
        await conn.query(
          'INSERT INTO preguntas (enunciado, opcion_A, opcion_B, opcion_C, opcion_D, respuesta_correcta) VALUES (?, ?, ?, ?, ?, ?)',
          [pregunta.enunciado, pregunta.opcion_A, pregunta.opcion_B, pregunta.opcion_C, pregunta.opcion_D, pregunta.respuesta_correcta],
        );
        print('Pregunta insertada correctamente');
      } else {
        print('La pregunta ya existe en la base de datos');
      }
    } catch (e) {
      print('Error al insertar la pregunta en la base de datos: $e');
    } finally {
      await conn.close();
    }
  }
}

//LAS PREGUNTAS
class PreguntaConOpciones {
  int idpregunta;
  String enunciado;
  String opcion_A;
  String opcion_B;
  String opcion_C;
  String opcion_D;
  String respuesta_correcta;

  PreguntaConOpciones({
    required this.idpregunta,
    required this.enunciado,
    required this.opcion_A,
    required this.opcion_B,
    required this.opcion_C,
    required this.opcion_D,
    required this.respuesta_correcta
  });

  factory PreguntaConOpciones.fromMap(ResultRow map) {
    return PreguntaConOpciones(
      idpregunta: map['idpregunta'],
      enunciado: map['enunciado'],
      opcion_A: map['opcion_A'],
      opcion_B: map['opcion_B'],
      opcion_C: map['opcion_C'],
      opcion_D: map['opcion_D'],
      respuesta_correcta: map['respuesta_correcta'],
    );
  }
}

Future<PreguntaConOpciones?> obtenerPreguntaAleatoria() async {
  var conn = await Database().conexion();
  try {
    var resultado = await conn.query('SELECT * FROM preguntas ORDER BY RAND() LIMIT 1');
    if (resultado.isNotEmpty) {
      return PreguntaConOpciones(
        idpregunta: resultado.first['idpregunta'],
        enunciado: resultado.first['enunciado'],
        opcion_A: resultado.first['opcion_A'],
        opcion_B: resultado.first['opcion_B'],
        opcion_C: resultado.first['opcion_C'],
        opcion_D: resultado.first['opcion_D'],
        respuesta_correcta: resultado.first['respuesta_correcta'],
      );
    } else {
      return null;
    }
  } catch (e) {
    print('Error al obtener la pregunta: $e');
    return null;
  } finally {
    await conn.close();
  }
}


void main() async {
  // Crear una instancia de la clase JuegoTrivial
  var juegoTrivial = JuegoTrivial();

  // Crear una lista de preguntas
  var preguntas = [
    PreguntaConOpciones(
      idpregunta: 1,
      enunciado: '¿Cuál es el nombre real de Iron Man?',
      opcion_A: 'Bruce Banner',
      opcion_B: 'Tony Stark',
      opcion_C: 'Steve Rogers',
      opcion_D: 'Peter Parker',
      respuesta_correcta: 'Tony Stark', // Especificar la respuesta correcta
    ),
    PreguntaConOpciones(
      idpregunta: 2,
      enunciado: '¿Cuál es el color primario del traje de Spider-Man?',
      opcion_A: 'Azul y rojo',
      opcion_B: 'Amarillo y negro',
      opcion_C: 'Verde y morado',
      opcion_D: 'Blanco y negro',
      respuesta_correcta: 'Azul y rojo', // Especificar la respuesta correcta
    ),
    PreguntaConOpciones(
      idpregunta: 3,
      enunciado: '¿Cuál es el villano principal en la película "Avengers: Infinity War"?',
      opcion_A: 'Thanos',
      opcion_B: 'Loki',
      opcion_C: 'Ultron',
      opcion_D: 'Red Skull',
      respuesta_correcta: 'Thanos', // Especificar la respuesta correcta
    ),
    PreguntaConOpciones(
    idpregunta: 8,
    enunciado: '¿Cuál es el nombre real de Hulk?',
    opcion_A: 'Bruce Banner',
    opcion_B: 'Steve Rogers',
    opcion_C: 'Clint Barton',
    opcion_D: 'Reed Richards',
    respuesta_correcta: 'Bruce Banner', // Respuesta correcta
  ),
  PreguntaConOpciones(
    idpregunta: 6,
    enunciado: '¿Qué actor interpreta a Deadpool en las películas de Marvel?',
    opcion_A: 'Ryan Reynolds',
    opcion_B: 'Hugh Jackman',
    opcion_C: 'Chris Hemsworth',
    opcion_D: 'Robert Downey Jr.',
    respuesta_correcta: 'Ryan Reynolds', // Respuesta correcta
  ),
  PreguntaConOpciones(
    idpregunta: 5,
    enunciado: '¿Cuál es el nombre de la inteligencia artificial que ayuda a Tony Stark en sus trajes?',
    opcion_A: 'J.A.R.V.I.S.',
    opcion_B: 'U.L.T.R.O.N.',
    opcion_C: 'F.R.I.D.A.Y.',
    opcion_D: 'E.D.I.T.H.',
    respuesta_correcta: 'J.A.R.V.I.S.', // Respuesta correcta
  ),
  PreguntaConOpciones(
    idpregunta: 3,
    enunciado: '¿Quién es el líder de los X-Men?',
    opcion_A: 'Cyclops',
    opcion_B: 'Wolverine',
    opcion_C: 'Professor X',
    opcion_D: 'Magneto',
    respuesta_correcta: 'Professor X', // Respuesta correcta
  ),
  PreguntaConOpciones(
    idpregunta: 2,
    enunciado: '¿Cuál es el verdadero nombre de Black Widow?',
    opcion_A: 'Natasha Romanoff',
    opcion_B: 'Wanda Maximoff',
    opcion_C: 'Carol Danvers',
    opcion_D: 'Maria Hill',
    respuesta_correcta: 'Natasha Romanoff', // Respuesta correcta
  ),
    // Agregar más preguntas según sea necesario
  ];

  // Insertar todas las preguntas en la base de datos
  for (var pregunta in preguntas) {
    await juegoTrivial.insertarPreguntaConOpciones(pregunta);
  }
}