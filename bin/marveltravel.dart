import 'app.dart';
import 'database.dart';


main() async{
  await Database().instalacion();
  App().inicioApp();

}