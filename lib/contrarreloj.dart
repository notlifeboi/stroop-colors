import 'package:colorapp_flutter/menu.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Esta vista es parecida a juego.dart, por lo cuál omitiré comentarios que utilicé en este
// Explicaré cambios que hice para que sirviera solo por tiempo y no por intentos

class Contrarreloj extends StatefulWidget {
  // Las variables siguen siendo las mismas a las del juego original, sustituyendo la variable de intentos
  final int tiempo;
  final int pausa;
  final String modo;

  final Map<int, Map> colores = {
    0: {'nombre': 'Amarillo', 'color': Colors.yellow},
    1: {'nombre': 'Azul', 'color': Colors.blue},
    2: {'nombre': 'Verde', 'color': Colors.green},
    3: {'nombre': 'Rojo', 'color': Colors.red},
  };

  Contrarreloj({
    super.key,
    required this.tiempo,
    required this.pausa,
    required this.modo,
  });

  @override
  JuegoState createState() => JuegoState();
}

class JuegoState extends State<Contrarreloj> {
  late int segundos;
  late Timer temporizador;
  late int puntuacion;
  bool temporizadorC = false;
  bool mostrarBoton = true;
  // Ausencia de booleanos (acierto/error)que comprueban la respuesta
  // jugar() será solo para tiempo y manejaremos los datos desde comprobarSeleccion()
  late int indiceAleatorio;
  late List<int> clave;
  late Map<int, Map> coloresDesorganizados;
  late int pausaboton;
  late int puntuacionGuardar;
  late String modoJuego;
  bool pausado = false;
  bool contadorpausa = false;
  bool condicional = false;
  late int cantidadpalabras;
  late int palabrascorrectas;
  late int palabrasincorrectas;

  TextEditingController jugadorController = TextEditingController();

  @override
  void dispose() {
    temporizador.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    modoJuego = widget.modo;
    segundos = widget.tiempo ~/ 1000;
    pausaboton = widget.pausa;
    puntuacion = 0;
    cantidadpalabras = 0;
    palabrascorrectas = 0;
    palabrasincorrectas = 0;
    desorganizarColores();
  }

  void desorganizarColores() {
    setState(() {
      clave = widget.colores.keys.toList()..shuffle();
      coloresDesorganizados = {};
      for (int i = 0; i < clave.length; i++) {
        coloresDesorganizados[i] = widget.colores[clave[i]]!;
      }
    });
  }

  void comprobarSeleccion(Color index, Color comprobador) {
    // Manejo las condicionales de respuesta en comprobarSelección (caso contrario al modo vanilla)
    // El modo vanilla manejaba las condicionales en juego() y esta función retornaba un booleano
    // Variable declarada en false
    setState(() {
      // Si el color (variable index) es igual al color mostrado (comprobador)
      if (index == comprobador) {
        // Sumará una palabra total
        cantidadpalabras += 1;
        // Sumará una palabra correcta
        palabrascorrectas += 1;
        // Ganará una puntuación
        puntuacion += 10;
        // Desorganizará otra vez el array de colores
        desorganizarColores();
      } else {
        // Si no, solo sumará palabras incorrectas pero no desorganizará el array
        // Al ser modo contrarreloj, depende de cuántas palabras hagas en un x intervalo de tiempo
        // No se toma en cuenta un cambio de colores, sino hasta que acierte (Dandole sentido a este nuevo modo)
        palabrasincorrectas += 1;
      }
    });
  }

  // Esta función solo administra el tiempo
  void jugar() {
    contadorpausa = true;
    temporizadorC = true;
    // si el temporizadorC es declarado como true, empezará a contar
    if (temporizadorC == true) {
      temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          // Si el valor de segundos no ha llegado a 0, se irá drenando
          if (segundos >= 0) {
            segundos--;
          }
          // Si se queda sin tiempo
          if (segundos == -1) {
          // Cancelará el contador
          temporizador.cancel();
          // Desactivará el botón de pausa
          contadorpausa = false;
          // Desactivará el temporizador
          temporizadorC = false;
          // Reseteará los segundos
          segundos = widget.tiempo ~/ 1000;
          // Retornamos el valor anterior si se usaron tokens de pausa
          pausaboton = widget.pausa;
          // El botón para empezar el juego volverá a aparecer
          mostrarBoton = true;
          // Mostramos la nueva vista para volver al menú
          condicional = true;
          // Guardamos puntuación
          puntuacionGuardar = puntuacion;
          // Reseteamos el valor de puntuación
          puntuacion = 0;
        }
        });
      });
    }
  }

  // Mismo funcionamiento
  void pausarMenu(validacion) {
    setState(() {
      mostrarBoton = false;
      if (validacion == true) {
        pausaboton--;
        temporizador.cancel();
        temporizadorC = false;
      } else {
        temporizador.cancel();
        jugar();
        temporizadorC = true;
        if (pausaboton == 0) {
          contadorpausa = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'STROOP COLORS',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  // Si contadordepausa es true, tendrá acceso a la función de pausar
                  if (contadorpausa == true) pausarMenu(pausado = !pausado);
                },
                icon: const Icon(Icons.pause),
              ),
              title: Text('Pausas $pausaboton ',
                  style: const TextStyle(fontSize: 16)),
            ),
            body: Center(
                child: Column(children: [
              // Si el juego se acaba, activará condicional, generando una nueva vista
              if (condicional == true)
                Center(
                    child: Column(children: [
                  const Text(
                    '¡Gracias por participar!',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    // Mismo texto que el personalizado, invitamos al usuario a jugar por defecto
                    'Si quieres guardar tus puntajes, juega el modo por defecto'),
                  const SizedBox(height: 20),
                  // De igual manera mostramos sus estadísticas
                  Text('Palabras totales: $cantidadpalabras'),
                  Text('Aciertos: $palabrascorrectas'),
                  Text('Errores: $palabrasincorrectas'),
                  const SizedBox(height: 10),
                  // Mostramos también su puntuación
                  Text('Puntaje: $puntuacionGuardar'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      child: const Text('Volver'),
                      onPressed: () {
                        // Redirigimos al Menú
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ));
                      }),
                ]))
              else
                Stack(children: [
                  // si MostrarBoton existe, significa que el juego no ha iniciado
                  if (mostrarBoton == true)
                  // Al hacer click, este mismo se esconde y comienza el juego
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          mostrarBoton = false;
                          jugar();
                        });
                      },
                      child: const Text('Empezar'),
                    ),
                    // Si el intervalo de tiempo se activa
                  if (temporizadorC == true)
                  // Mismo menú que modo vanilla y personalizado
                    Container(
                      color: const Color(0xffFEF7FF),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Palabras totales $cantidadpalabras'),
                                    Text('Aciertos $palabrascorrectas'),
                                    Text('Fallos $palabrasincorrectas'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Tiempo: $segundos',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Puntuación: '),
                                    Text(
                                      '$puntuacion',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Text(
                                  coloresDesorganizados[0]!['nombre'],
                                  style: TextStyle(
                                    color: coloresDesorganizados[1]!['color'],
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
                // Mismo panel de botones
              const SizedBox(height: 50),
              if (temporizadorC == true)
                SizedBox(
                    height: 220,
                    width: 220,
                    child: GridView.count(crossAxisCount: 2, children: [
                      for (int c = 0; c < clave.length; c++)
                        ElevatedButton(
                          onPressed: () {
                            comprobarSeleccion(
                              coloresDesorganizados[clave[c]]!['color'],
                              coloresDesorganizados[1]!['color'],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                coloresDesorganizados[clave[c]]!['color'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide.none,
                            ),
                          ),
                          child: const Text(''),
                        )
                    ]))
            ]))));
  }
}
