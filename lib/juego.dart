import 'package:colorapp_flutter/menu.dart';
import 'package:flutter/material.dart';
// Importamos librería para poder utilizar nuestro Timer
import 'dart:async';
// Importamos librería de fluttertoast para mostrar el mensaje del usuario (cuando el campo username esté vacio)
import 'package:fluttertoast/fluttertoast.dart';
import 'package:colorapp_flutter/leaderboard.dart';
// Importamos providers para guardar datos en la librería
import 'package:provider/provider.dart';
import 'package:colorapp_flutter/providers/counter_provider.dart';

class Juego extends StatefulWidget {
  // Creamos variables para poder guardar el contenido de los parámetros
  final int intentos;
  final int tiempo;
  final int pausa;
  final String modo;

  // Creamos un array de colores, con valores fijos que se irán asignando para el desarrollo del juego
  final Map<int, Map> colores = {
    0: {'nombre': 'Amarillo', 'color': Colors.yellow},
    1: {'nombre': 'Azul', 'color': Colors.blue},
    2: {'nombre': 'Verde', 'color': Colors.green},
    3: {'nombre': 'Rojo', 'color': Colors.red},
  };

  Juego({
    super.key,
    // Requerimos las variables que vendrán de los parámetros y guardar su contenido
    required this.intentos,
    required this.tiempo,
    required this.pausa,
    required this.modo,
  });

  @override
  JuegoState createState() => JuegoState();
}

class JuegoState extends State<Juego> {
  // Creamos variables que almacenarán los datos de los parámetros
  late int segundos;
  late Timer temporizador;
  late int intentos;
  late int puntuacion;
  // Booleano que se usará para el contador de pausa
  // cuando sea true reanudará el conteo del Timer
  // cuando sea false pausará el desarrollo Timer
  bool temporizadorC = false;
  // Booleano que controlado la visibilidad del botón con el cuál empezamos el juego
  // cuando sea false, el boton desaparece
  // cuando sea true, el botón volverá a aparecer
  bool mostrarBoton = true;
  // Booleanos que se usarán para dar respuesta a si la opción del jugador coincide con la tinta de la letra
  bool acierto = false;
  bool error = false;
  // indiceAleatorio servirá para generar un número aleatorio para poder ser asignado como indice del array
  late int indiceAleatorio;
  // Utilizado para desglosar (y aleatorizar) las claves del array de colores
  late List<int> clave;
  // Array nuevo para guardar el array de colores desorganizado
  late Map<int, Map> coloresDesorganizados;
  // Creamos una variable que contendrá el valor de pausa
  late int pausaboton;
  // Creamos una variable que contendrá el valor de puntuación
  late int puntuacionGuardar;
  // Creamos una variable que contendrá el valor de modo de juego
  late String modoJuego;
  // Booleano que servirá como switch para pausar o despausar el juego
  bool pausado = false;
  // Servirá para bloquear el botón en caso de que se acaben los intentos de pausa
  bool contadorpausa = true;
  // Esta condicional servirá para mostrar un nuevo contenido cuando se acabe el juego
  // Cuando sea true, mostrará el apartado para colocar su nombre o si es personalizado para volver al menú
  bool condicional = false;
  // Variables para mostrar la cantidad de palabras que aparecieron en la pantalla, así como cuántas acertó y falló el usuario
  late int cantidadpalabras;
  late int palabrascorrectas;
  late int palabrasincorrectas;
  // Variable de emergencia para mostrar un contador de pausa en 0 en caso de que se quede sin intentos
  late int pausabotonM;

  TextEditingController jugadorController = TextEditingController();

  // Creamos una variable que servirá cuando
  // Si por error o voluntariamente se sale de la vista actual, el contador dejará de contar
  // EN caso contrario, si dejamos que el temporizador siga contando fuera de la vista el aplicativo fallará
  @override
  void dispose() {
    temporizador.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //Inicializamos variables
    super.initState();
    // se usa widget al venir de un stateless
    modoJuego = widget.modo;
    intentos = widget.intentos;
    // Dividimos el tiempo entre 1000 para hacer la conversión a segundos
    segundos = widget.tiempo ~/ 1000;
    pausaboton = widget.pausa;
    puntuacion = 0;
    // La definimos las variables que contarán las palabras, errores y aciertos
    cantidadpalabras = 0;
    palabrascorrectas = 0;
    palabrasincorrectas = 0;
    // Desorganizamos el array para que cada inicio de juego sea distinto
    desorganizarColores();
    // Definimos nuestra variable de emergencia para que contenga el valor de pausaboton
    pausabotonM = pausaboton;
  }

  void desorganizarColores() {
    setState(() {
      // Asignamos claves que se irán volviendo aleatorias al array
      clave = widget.colores.keys.toList()..shuffle();
      // Inicializamos el array donde vamos a pasar los datos
      coloresDesorganizados = {};
      for (int i = 0; i < clave.length; i++) {
        // Se irán escribiendo los datos del array colores en base a la clave aleatoria
        coloresDesorganizados[i] = widget.colores[clave[i]]!;
      }
    });
  }

  void comprobarSeleccion(Color index, Color comprobador) {
    setState(() {
      // Si el color elegido (variable index) es igual al color mostrado (variable comprobador)
      if (index == comprobador) {
        // Se activará el booleano de aciertos
        acierto = true;
      } else {
        // En caso contrario, activará el booleano de error
        error = true;
      }
    });
  }

  // Esta función es donde estará toda la lógica del juego
  void jugar() {
    // Booleano para empezar el conteo
    // está fuera del setState entonces solo se reiniciara una vez la función vuelva a ser activada
    temporizadorC = true;
    if (temporizadorC == true) {
      // FUnción de la biblioteca Timer para crear el intervalo de tiempo (en este caso de cada segundo)
      temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
        // Consecuencia del timer: cada acción que se haga dentro del Timer será reflejada 1 segundo después
        // Esto es útil ya que de este modo prohibimos la entrada de otros validadores o spam de clicks para sumar puntos
        setState(() {
          // Si el contador de segundos es mayor a 0 seguirá drenando los segundos periódicamente
          if (segundos >= 0) {
            segundos -= 1;
            // Ejecución de código en caso de que acierto sea true
            if (acierto == true) {
              // Se devolverá a false para cortar el ciclo
              acierto = false;
              // Sumamos una palabra
              cantidadpalabras += 1;
              // Sumamos un acierto
              palabrascorrectas += 1;
              // Sumamos puntuación obtenida
              puntuacion += 10;
              // Reseteamos los segundos y los colores
              segundos = widget.tiempo ~/ 1000;
              desorganizarColores();
            }
            // Ejecución de código en caso de que error sea true
            // Funciona de la misma manera que el if acierto
            if (error == true) {
              error = false;
              cantidadpalabras += 1;
              // En caso contrario, sumará un error
              palabrasincorrectas += 1;
              intentos -= 1;
              segundos = widget.tiempo ~/ 1000;
              desorganizarColores();
            }
            // Establezco el if en -1 para que el usuario pueda jugar por 3 segundos (contando el segundo 0)
            // Si se acaba el tiempo
            if (segundos == -1) {
              // Suma una palabra
              cantidadpalabras += 1;
              // Suma un error
              palabrasincorrectas += 1;
              // Pierde una vida
              intentos--;
              // Se reinicia tiempo y colores
              segundos = widget.tiempo ~/ 1000;
              desorganizarColores();
            }
            // Si se queda sin vidas (intentos)
            if (intentos == 0) {
              // El intervalo de tiempo se desactivará (para que no siga contando en segundo plano)
              temporizador.cancel();
              // Desactivamos el botón de pausa y el booleano del intervalo
              contadorpausa = false;
              temporizadorC = false;
              // Reseteamos los valores que estaban por defecto después del juego
              intentos = widget.intentos;
              segundos = widget.tiempo ~/ 1000;
              pausaboton = widget.pausa;
              // El botón para empezar el juego aparecerá de nuevo
              mostrarBoton = true;
              // Condicional para simular el cambio de pantalla (para ingresar el usuario)
              condicional = true;
              // Guardamos el puntaje y lo reseteamos a 0
              puntuacionGuardar = puntuacion;
              puntuacion = 0;
            }
          }
        });
      });
    }
  }

  void pausarMenu(bool validacion) {
    setState(() {
      // Cada vez que pausa/despausa irá restando -1 en el contador
      pausaboton -= 1;
      // Cuando pausas
      if (validacion == true) {
        // Esta variable solo restará cuando se clickee el botón (Simula el efecto que perdió un token de pausa)
        pausabotonM -= 1;
        //Restablecemos y organizamos el código para cuando despause el juego
        segundos = widget.tiempo ~/ 1000;
        temporizador.cancel();
        temporizadorC = false;
        desorganizarColores();
        // Cuando despausas
      } else {
        // Reiniciará el juego
        temporizadorC = true;
        jugar();
      }
      // Si pausaboton se encuentra con su valor negativo
      // Ejemplo: tokens de pausa 7 (valor negativo -7)
      if (pausaboton == -widget.pausa.toInt()) {
        // El botón de pausar dejará de servir
        contadorpausa = false;
        // se mostrará por medio de esta variable que se quedó sin tokens para seguir pausando
        pausabotonM = 0;
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
                  // Si el booleano que controla la accesibilidad al botón es true
                  if (contadorpausa == true) {
                    // Ejecutará la función alternando el valor (True o False) de pausado
                    pausarMenu(pausado = !pausado);
                  }
                },
                icon: const Icon(Icons.pause),
              ),
              // Acá utilizaremos la variable de emergencia mencionada (pausabotonM) para mostrar los tokens disponibles
              title: Text('Pausas $pausabotonM ',
                  style: const TextStyle(fontSize: 16)),
              actions: [
                // Si hay más de 10 intentos (para juegos personalizados) Se acortarán en un texto para que no se desborde de la pantalla
                if (intentos > 10)
                  Row(
                    children: [
                      Text('Vidas restantes: $intentos '),
                      const Icon(Icons.favorite, color: Colors.red),
                    ],
                  )
                // Si hay 10 vidas o menos
                else
                  //Creará un row (una fila de vidas)
                  Row(
                    // Creará una lista en base a cuántos intentos le quedan
                    children: List.generate(
                      intentos,
                      (index) => const Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                const SizedBox(width: 10),
              ],
            ),
            body: Center(
                child: Column(children: [
              // Condicional solo se activará cuando el juego acabe (Sea por tiempo o por intentos)
              // Esta es la vista donde pediremos el nombre al usuario para poder guardar su puntaje
              if (condicional == true)
                // Si el modo es vanilla se podrá acceder a una vista distinta a la que muestra si estás en modo personalizado
                if (widget.modo.toString() == 'Vanilla')
                  Center(
                    child: Column(
                      children: [
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
                            // Solicitamos el usuario
                            'Digita tu usuario para poder ver los puntajes'),
                        const SizedBox(height: 20),
                        // Mostramos las estadísticas de su ronda
                        Text('Palabras totales: $cantidadpalabras'),
                        Text('Aciertos: $palabrascorrectas'),
                        Text('Errores: $palabrasincorrectas'),
                        const SizedBox(height: 10),
                        // Mostramos su puntaje
                        Text('Puntaje: $puntuacionGuardar'),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 200,
                          height: 30,
                          //TextField para que el usuario digite su nombre
                          child: TextField(
                            // Controlador para hacer la validación
                            controller: jugadorController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Botón que validará si existe algo registrado en el TextField de usuario
                        ElevatedButton(
                            onPressed: () {
                              // Definirá una nueva variable llamada username
                              // El trim le quitará los espacios del inicio y del final al nombre escrito
                              String username = jugadorController.text.trim();
                              // Si no encuentra un nombre
                              if (username.isEmpty) {
                                // Usaremos un flutttertoast (alerta) diciendo que digite un usuario
                                Fluttertoast.showToast(
                                  msg: "Digite un usuario",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                // Si encuentra el usuario
                              } else {
                                // LLamamos el provider con la función de crear un nuevo dato
                                Provider.of<CounterProvider>(context,
                                        listen:
                                            false) // Esto es para que no se vuelva a generar el array
                                    .nuevoDato(username, puntuacionGuardar,
                                        modoJuego); // Le pasamos los datos a guardar en el array
                                // Redirigimos a la vista de puntuaciones
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Leaderboard(),
                                    ));
                              }
                            },
                            child: const Text('Enviar')),
                      ],
                    ),
                  )
                // Si el modo no es vanilla mostrará una vista donde se le indicará que sus datos no serán guardados
                else
                  Center(
                    child: Column(
                    children: [
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
                        // Invitamos a jugar al modo por defecto
                        'Si quieres guardar tus puntajes, juega el modo por defecto', textAlign: TextAlign.center),
                    // De igual manera mostraremos sus estadísticas
                    const SizedBox(height: 20),
                    Text('Palabras totales: $cantidadpalabras'),
                    Text('Aciertos: $palabrascorrectas'),
                    Text('Errores: $palabrasincorrectas'),
                    const SizedBox(height: 10),
                    // Mostramos su puntaje
                    Text('Puntaje: $puntuacionGuardar'),
                    const SizedBox(
                      height: 10,
                    ),
                    // Creamos un botón para que se puedan devolver al menú
                    ElevatedButton(
                        child: const Text('Volver'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Menu(),
                              ));
                        }),
                  ]))
              // Continuación de if (condicional == true)
              // Si el juego no ha terminado (O no ha empezado) mostrará esta vista
              else
                Stack(children: [
                  // si el booleano de mostrarboton es tre, mostrará el botón para empezar el juego
                  // Utilizado para que no aparezca más durante el trasncurso del juego
                  if (mostrarBoton == true)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Se autodesactiva al dar click, y empezará el juego
                          mostrarBoton = false;
                          jugar();
                        });
                      },
                      child: const Text('Empezar'),
                    ),
                  // Cuando el intervalo sea true
                  if (temporizadorC == true)
                    Container(
                      // Este contenedor es para mostrar todo el juego, tanto paneles como estadísticas
                      color: const Color(0xffFEF7FF),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              // este crossAxisAlignment y el siguiente es para alinear tanto el contenedor como los elementos al inicio (izquierda)
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Estadísticas de juego
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
                                  // El tiempo por ronda
                                  'Tiempo: $segundos',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  // Utilizamos mainAxisAlignment, para centrar el contenido de este Row
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Mostramos la puntuación
                                    const Text('Puntuación: '),
                                    Text(
                                      // Separamos el texto del puntaje, para que puntaje sea más significativo
                                      '$puntuacion',
                                      style: const TextStyle(
                                          // Le ponemos negrilla al puntaje
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Text(
                                  // Acá se mostrará desde el array desorganizado
                                  // el nombre (Nombre del color)
                                  // asignación de color (Valores de color)
                                  // El texto que saldrá será el primer elemento del array
                                  coloresDesorganizados[0]!['nombre'],
                                  style: TextStyle(
                                    // Su propiedad de color será en el segundo elemento para que sean diferentes
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
              const SizedBox(height: 50),
              // También creamos otro contenedor que se activa cuando empieza el intervalo de tiempo
              if (temporizadorC == true)
                // Acá estarán los paneles de selección
                SizedBox(
                    height: 220,
                    width: 220,
                    // Será una grilla que contará cada 2 elementos por fila
                    child: GridView.count(crossAxisCount: 2, children: [
                      // Inicializamos un for que irá desde 0 hasta la longitud del array Clave
                      for (int c = 0; c < clave.length; c++)
                        ElevatedButton(
                          onPressed: () {
                            // Cuando se presione el botón, validará y dará una respuesta de la selección
                            comprobarSeleccion(
                              // Pasamos los parámetros
                              coloresDesorganizados[clave[c]]!['color'], // El color seleccionado
                              coloresDesorganizados[1]!['color'], // El color respuesta
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              // Con el mismo for (c), les damos colores aleatorios
                              // El índice se llamará de la variable clave, para que no quede siempre igual en orden
                                  coloresDesorganizados[clave[c]]!['color'],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide.none,
                              )),
                            // Texto vacio porque siguen siendo botones y no queremos texto
                          child: const Text(''),
                        )
                    ]))
            ]))));
  }
}
