import 'dart:io';
import 'usuario.dart';
import 'juego.dart';
import 'database.dart';
import 'personaje.dart';

class App {
  inicioApp() {
    int? opcion;
    do {
      stdout.writeln('''¡Hola listillo!, antes de empezar debes elegir una opción
      1- Crear usuario
      2- Iniciar sesión''');
      String respuesta = stdin.readLineSync() ?? 'e';
      opcion = int.tryParse(respuesta);
    } while (opcion == null || opcion != 1 && opcion != 2);
    switch (opcion) {
      case 1:
        crearUsuario();
        break;
      case 2:
        login();
        break;
      default:
        print('Opción incorrecta');
    }
  }

  AppIniciada(Usuario usuario) async {
    int? opcion;
    String? nombre = usuario.nombre;
    do {
      stdout.writeln('''¡Bienvenido $nombre a Marvel Trivial, ingrese el número correspondiente a la opción deseada
      1- Ver perfil
      2- Empezar Trivial
      3- Personajes
      4- Cerrar sesión
      ''');
      String respuesta = stdin.readLineSync() ?? 'e';
      opcion = int.tryParse(respuesta);
    } while (opcion == null || opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4);
    switch (opcion) {
      case 1:
        mostrarPerfil(usuario);
        break;
      case 2:
        empezarTrivial(usuario);
        break;
      case 3:
      mostrarPersonajesDisponibles(usuario);
        break;
      case 4:
        print('¡Hasta la proxima $nombre!');
        inicioApp();
        break;
      default:
        print('Opción incorrecta');
    }
  }


//CASE 1 INICIO APP
  crearUsuario() async {
    Usuario usuario = new Usuario();
    stdout.writeln('Introduce un nombre de usuario');
    usuario.nombre = stdin.readLineSync();
    stdout.writeln('Introduce una constraseña');
    usuario.password = stdin.readLineSync();
    usuario.password = usuario.password;
    await usuario.insertarUsuario();
    AppIniciada(usuario);
  }

//CASE 2 INICIO APP
  login() async {
    Usuario usuario = new Usuario();
    stdout.writeln('Introduce tu nombre de usuario');
    usuario.nombre = stdin.readLineSync();
    stdout.writeln('Introduce tu constraseña');
    usuario.password = stdin.readLineSync();
    var resultado = await usuario.loginUsuario();
    if (resultado == false) {
      stdout.writeln('Tu nombre de usuario o contraseña son incorrectos');
      inicioApp();
    } else {
      AppIniciada(usuario);
    }
  }


  //CASE 1 APP INCIDIADA
    mostrarPerfil(Usuario usuario) async {
  // Obtener la puntuación del usuario desde la base de datos
  int puntuacion = await Database().obtenerPuntuacion(usuario.idusuario!);
  // Mostrar la puntuación del usuario
   print('Puntuación acumulada: $puntuacion');
   stdout.write('Presiona "Enter" para volver al menú o "q" para salir');
    String? decision = stdin.readLineSync()?.toLowerCase();
    if (decision == 'q') {
      print('!Que rápido te has ido!, bye bye.');
      return;
    } else {
      await AppIniciada(usuario);
    }
  }
  


    //CASE 2 APP INCIDIADA
    Future empezarTrivial(Usuario usuario) async {
    if (usuario.idusuario == null) {
      print('Error: el ID de usuario es null.');
      return;
    }

    List<int> preguntasRealizadas = [];
    int puntuacion = 0;
    int preguntasRespondidas = 0;

    print('¡Bienvenido al Trivial de Marvel, ${usuario.nombre}!');
    print('Responde las siguientes preguntas para demostrar tus conocimientos:');

    while (preguntasRespondidas < 5) {
      PreguntaConOpciones? pregunta = await obtenerPreguntaAleatoria();
      if (pregunta == null) {
        print('No se pudieron cargar las preguntas. Inténtelo más tarde.');
        return;
      }

      if (preguntasRealizadas.contains(pregunta.idpregunta)) {
        continue;
      }

      preguntasRealizadas.add(pregunta.idpregunta);
      preguntasRespondidas++;

      print('Pregunta: ${pregunta.enunciado}');
      print('Opciones:');
      print('A) ${pregunta.opcion_A}');
      print('B) ${pregunta.opcion_B}');
      print('C) ${pregunta.opcion_C}');
      print('D) ${pregunta.opcion_D}');

      stdout.write('Respuesta (A/B/C/D): ');
      String? respuesta = stdin.readLineSync()?.toUpperCase();

      if (respuesta == null || !['A', 'B', 'C', 'D'].contains(respuesta)) {
        print('Respuesta inválida. Intente nuevamente.');
        continue;
      }

      String respuestaUsuario;
      switch (respuesta) {
        case 'A':
          respuestaUsuario = pregunta.opcion_A;
          break;
        case 'B':
          respuestaUsuario = pregunta.opcion_B;
          break;
        case 'C':
          respuestaUsuario = pregunta.opcion_C;
          break;
        case 'D':
          respuestaUsuario = pregunta.opcion_D;
          break;
        default:
          respuestaUsuario = '';
      }

      if (respuestaUsuario == pregunta.respuesta_correcta) {
        print('¡Respuesta correcta!');
        puntuacion += 6;
      } else {
        print('Respuesta incorrecta. La respuesta correcta es: ${pregunta.respuesta_correcta}');
        puntuacion -= 3;
        if (puntuacion == 0 || puntuacion <= 0 ) {
          print('¡Has perdido! Tu puntuación ha llegado a 0.');
          continue;
        }
      }

      print('Puntuación actual: $puntuacion');
      print('---------------------');
    }

    await Database().guardarPuntuacion(usuario.idusuario!, puntuacion);

    // Redirigir a AppIniciada con el usuario actualizado
    print('Fin del juego trivial');
    print('Tu puntuación final es: $puntuacion');
    stdout.write('Presiona "Enter" para volver al menú principal o "q" para salir: ');
    String? decision = stdin.readLineSync()?.toLowerCase();
    if (decision == 'q') {
      print('¡Gracias por jugar! Hasta luego.');
      return;
    } else {
      await AppIniciada(usuario);
    }
  }

//CASE 3 APP INICIADA
  mostrarPersonajesDisponibles(Usuario usuario) async {
   int puntuacion = await Database().obtenerPuntuacion(usuario.idusuario!);
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query('SELECT * FROM personajes WHERE puntos_requeridos <= ?', [puntuacion]);
      if (resultado.isNotEmpty) {
        print('Personajes disponibles para comprar:');
        for (var row in resultado) {
          var personaje = Personaje.fromMap(row);
          print('ID: ${personaje.idpersonaje}');
          print('Nombre: ${personaje.nombre}');
          print('Descripción: ${personaje.descripcion}');
          print('Habilidad: ${personaje.habilidad}');
          print('Imagen URL: ${personaje.imagen_url}');
          print('Puntos Requeridos: ${personaje.puntos_requeridos}');
          print('');
        }
      } else {
        print('No hay personajes disponibles para comprar.');
      }
    } catch (e) {
      print('Error al obtener los personajes disponibles: $e');
    } finally {
      await conn.close();
      stdout.write('Presiona "Enter" para volver al menú principal o "q" para salir: ');
    String? decision = stdin.readLineSync()?.toLowerCase();
    if (decision == 'x') {
      print('¡Gracias por jugar! Hasta luego.');
      return;
    } else {
      await AppIniciada(usuario);
    }
    }
  }
}