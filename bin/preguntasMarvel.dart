import 'package:mysql1/mysql1.dart';

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