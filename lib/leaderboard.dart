import 'package:flutter/material.dart';
import 'package:colorapp_flutter/menu.dart';
// Importamos providers
import 'package:provider/provider.dart';
import 'package:colorapp_flutter/providers/counter_provider.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEADERBOARD',
      home: Scaffold(
        appBar: AppBar(
          // Nuesro titulo del appBar para indicar que estamos en la vista leaderboard
          title: const Text("Puntuaciones locales", style: TextStyle(fontSize: 25)),
          // Al hacer click a este botón, redireccionará a Menú
          leading: IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu()));
            },
          ),
        ),
        body: Column(
          children: [
            const Text('Se mostrarán los mejores 5 puntajes obtenidos'),
            // Analizamos el array que se está creando por medio de nuestro provider (Guardar datos de juego)
            // Si está vacio significa que todavia no se han guardado puntajes
            if(context.watch<CounterProvider>().top.isEmpty)
            const Center(
              child: Text('Todavia no hay puntajes guardados'),
            )
            // Si no, significará que si hay datos contenidos y los mostrará
            else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                // Utilizamos un ListView para facilitar el proceso de impresión de datos
                child: ListView.builder(
                // Limitamos la lista de datos hasta 5, que serán los 5 mejores puntajes
                itemCount: 5,
                itemBuilder: (context, index) {
                  // Index es la posición actual del elemento en la lista
                  if (index >= context.watch<CounterProvider>().top.length) {
                    // Si el index está fuera del rango requerido, devolverá un SizedBox vacio
                    return const SizedBox.shrink();
                  }
                  // declaramos una variable llamada datosusuario, que contendrá el index actual que recorre el ListView
                  // Top es el array donde están los datos que se guardan en el juego default
                  final datosUsuario = context.watch<CounterProvider>().top[index];
                  return ListTile(
                    title: Text(
                      // Llamamos clave (datousuario) valor (usuario)
                      '${datosUsuario['usuario']}',
                    ),
                    subtitle: Text(
                      // Mismo caso acá
                      // clave (datousuario) valor (puntuacion)
                      // clave (datousuario) valor (modo)
                      'Puntaje: ${datosUsuario['puntuacion']} - ${datosUsuario['modo']}'),
                  );
                },
              ),
            )
          )]
        ),
      )
    );
  }
}
