// Importamos librería del material de flutter (Diseño del aplicativo)
import 'package:flutter/material.dart';
// Importamos libreria lottie para el splashscreen
import 'package:lottie/lottie.dart';
// Importamos libreria animated_splash_screen para poder usar el splashscreen
import 'package:animated_splash_screen/animated_splash_screen.dart';
// Importamos la vista donde empieza el juego
import 'package:colorapp_flutter/menu.dart';
// Importamos la librería del provider para manejar datos
import 'package:provider/provider.dart';
import 'package:colorapp_flutter/providers/counter_provider.dart';

void main() {
  // Modificamos el main para que todo sea cubierto por el sistema de providers
  //changeNotifierProver ayuda a que los listeners actuen
  runApp(ChangeNotifierProvider(
    // Se inicializa el provider (CounterProvider es su nombre)
    create: (_) => CounterProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retornamos el material app de flutter (Diseño del aplicativo)
    return MaterialApp(
      // Titulo que dirá cargando porque el main solo tendrá el splashscreen
        title: 'CARGANDO...',
        // Quitamos el aviso de debug que aparece en la esquina de la pantalla
        debugShowCheckedModeBanner: false,
        // Definimos el widget home con Scaffold para empezar con la estructura
        home: Scaffold(
          // Retornamos el widget AnimatedSplashScreen
          body: AnimatedSplashScreen(
            // Ponemos el JSON de la animación que hicimos en el website de lottie
            splash: Lottie.asset('assets/images/inicio.json'),
            // Redireccionamos al menú de inicio (En este caso el home del aplicativo)
            nextScreen: const Menu(),
            // Definimos la duración del splashscreen
            duration: 4000,
            // Definimos el tamaño del ícono
            splashIconSize: 300,
            // definimos una animación después de que se acabe el SplashScreen
            splashTransition: SplashTransition.sizeTransition,
          ),
        ));
  }
}
