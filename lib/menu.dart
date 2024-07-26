// Importamos el endDrawer que viene desde config.dart
import 'package:colorapp_flutter/config.dart';
// Importamos librería del material de flutter (Diseño del aplicativo)
import 'package:flutter/material.dart';
// Importamos la vista del juego
import 'package:colorapp_flutter/juego.dart';
// Importamos la vista de puntuaciones locales
import 'package:colorapp_flutter/leaderboard.dart';

// Definimos variables estáticas
class Menu extends StatelessWidget {
  // Numero de intentos
  final int intentos = 3;
  // Tiempo
  final int tiempo = 3000;
  // Botón de pausa (Dos disponibles por sesión)
  final int pausa = 2;
  // Modo para trabajar la condicional de juego
  final String modo = 'Vanilla';
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    // Retornamos el material app de flutter (Diseño del aplicativo)
    return MaterialApp(
      // Quitamos el aviso de debug que aparece en la esquina de la pantalla
      debugShowCheckedModeBanner: false,
      // Stroop Colors proviene del efecto Stroop el cuál es mencionado en la guia
      title: 'STROOP COLORS',
      // Definimos el widget home con Scaffold para empezar con la estructura
      home: Scaffold(
        // Abrimos un appBar que contendrá la configuración del juego
        appBar: AppBar(
          // Generamos un botón (Lado izquierdo) de nuestro leaderboard
          leading: IconButton(
              onPressed: () {
                //Cuando se presione, dirigirá a la vista de puntuaciones
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Leaderboard()));
              },
              // El icono que tendrá el iconButton
              icon: const Icon(Icons.star)),
            // Acciones que podemos encontrar (Lado derecho)
            actions: [
            // Generamos un constructor (Para encapsular el endDrawer)
            Builder(builder: (BuildContext context) {
              // Retornará el iconButton (Si no lo hacemos no funcionará el Scaffold y marcará error)
              return IconButton(
                  onPressed: () {
                    // Al ser presionado, buscará dentro de la estructura, el widget endDrawer y lo ejecutará
                    Scaffold.of(context).openEndDrawer();
                  },
                  // Definimos el ícono del botón
                  icon: const Icon(Icons.settings));
            })
            //Un botón que se muestra como ícono
          ],
        ),
        // Traemos el contenido del endDrawer (lado derecho) a esta vista, usará la vista de Config (Para el juego personalizado)
        endDrawer: const Config(),
        // Creamos un body center para que toda la información esté centrada
        body: Center(
          // Creamos una columna para que no haya desbordamiento por los lados
          child: Column(
            children: [
              // Traemos el logo de Stroop Colors, con width y height de 400
              Image.asset('assets/images/logo.png', width: 300, height: 300),
              // Generamos un texto para que no quede tan vacio
              const Text(
                'Test de Stroop',
                // Le damos estilo
                style: TextStyle(
                  // Tamaño
                  fontSize: 30,
                  // Grosor
                  fontWeight: FontWeight.w900,
                  // Color
                  color: Color.fromARGB(255, 182, 186, 251),
                ),
              ),
              // Creamos un SizedBox para hacer un margen entre el texto y el botón
              const SizedBox(height: 30),
              // Creamos un botón para empezar el juego
              ElevatedButton(
                onPressed: () {
                  // Redireccionamos al juego
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Juego(
                        //LLevamos las variables que se usarán
                        intentos: intentos,
                        tiempo: tiempo,
                        pausa: pausa,
                        modo: modo
                        // variable de la vista: variable de esta vista
                      )
                    ),
                  );
                },
                // Le damos estilo al botón
                style: ElevatedButton.styleFrom(
                  // Color de fondo
                  backgroundColor: const Color.fromARGB(255, 182, 186, 251),
                ),
                // Definimos que dirá el botón
                child: const Text(
                  'Empezar',
                  // Le damos estilo al texto
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
