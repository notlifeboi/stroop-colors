//Es la primera vez que uso un provider
// Fuentes: https://www.youtube.com/watch?v=tuQ8j0IZI-0

import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  // Estas 3 varibles se utilizarán para cambiar los datos cuando sean modificados en el juego personalizado
  int _intentos = 3;
  int _tiempo = 3000;
  int _pausa = 2;
  // Se inicializa un array vacio, que servirá para guardar el leaderboard de los que jueguen
  final List<Map<String, dynamic>> _top = [];

  // Desarrollamos los getters
  int get intentos => _intentos;
  int get tiempo =>_tiempo;
  int get pausa => _pausa;
  List<Map<String, dynamic>> get top => _top;

  // Desarrollamos una función de nuevoDato, donde se irán anexando los nuevos datos que entren al array
  void nuevoDato(String username, int puntuacion, String modo) {
    _top.add({
      'usuario': username,
      'puntuacion': puntuacion,
      'modo': modo,
    });
  // Por último, organizamos las puntuaciones de mayor a menor
  // a serán las puntuaciones mayores, y se irán comparando constantemente con b
  _top.sort((a, b) => b['puntuacion'].compareTo(a['puntuacion']));
    notifyListeners();
  }

  // Desarrollamos funciones para actualizar los valores de intentos, tiempo y pausa del juego personalizado
  void actualizarIntentos(int nuevoValor) {
    _intentos = nuevoValor;
    notifyListeners();
  }

  void actualizarTiempo(int nuevoValor) {
    _tiempo = nuevoValor;
    notifyListeners();
  }

  void actualizarPausa(int nuevoValor) {
    _pausa = nuevoValor;
    notifyListeners();
  }
  // el uso de notifyListeners ayuda a que dentro de los providers, puedan actuar estas funciones y poder ver los cambios
}
