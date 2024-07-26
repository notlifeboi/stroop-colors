import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colorapp_flutter/providers/counter_provider.dart';
import 'package:colorapp_flutter/juego.dart';
import 'package:colorapp_flutter/contrarreloj.dart';

class Config extends StatefulWidget {
  const Config({super.key});
  @override
  ConfigState createState() => ConfigState();
}

class ConfigState extends State<Config> {
  // Generamos los controladores de los TextFields a usar
  late TextEditingController _intentosController;
  late TextEditingController _tiempoController;
  late TextEditingController _pausaController;
  // Generamos variables que almacenarán los datos de los controladores (para evitar conversiones)
  late int vIntentos;
  late int vTiempo;
  late int vPausa;
  // Al ser una pestaña para configurar un juego personalizado, tendrá este otro modo de juego
  late String modo = 'Personalizado';

  @override
  void initState() {
    super.initState();
    // Inicializamos nuestro provider para traer los datos de este
    final counterProvider = context.read<CounterProvider>();
    // Los controladores tendrán un texto por defecto que serán las variables de los providers
    _intentosController =
        TextEditingController(text: counterProvider.intentos.toString());
    _tiempoController =
        TextEditingController(text: counterProvider.tiempo.toString());
    _pausaController =
        TextEditingController(text: counterProvider.pausa.toString());
    // Se hace esto para mantener los datos cada vez que quiera iniciar un nuevo juego personalizado
    // Si se modifican los datos de entrada antes del juego, también se modificarán
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
              // El navigator.pop(context) envía una vista atrás, que en este caso es config.dart
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_left),
          ),
          title: const Text('Configuración'),
          actions: [
            // Este botón será para el modo contrarreloj
            IconButton(
                onPressed: () {
                  // Convertimos los valores de los controladores en variables que estaban esperando su valor (Late)
                  vTiempo = int.tryParse(_tiempoController.text) ?? 0;
                  vPausa = int.tryParse(_pausaController.text) ?? 0;
                  // Desplegamos las funciones para actualizar los nuevos valores de pausa y tiempo
                  Provider.of<CounterProvider>(context, listen: false)
                      .actualizarTiempo(vTiempo);
                  Provider.of<CounterProvider>(context, listen: false)
                      .actualizarPausa(vPausa);
                  // Mandamos a la vista de modo de juego 3, en este caso contrarreloj
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Contrarreloj(
                        // Le mandamos las variables, este modo de juego no tendrá intentos
                        tiempo: vTiempo,
                        pausa: vPausa,
                        modo: modo,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.access_alarms))
          ],
        ),
        // En el body asigno controladores a los TextField para que puedan modificar su juego libre
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Configura el juego a tu gusto',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                // Pedimos numero de intentos (Omitibile para modo contrarreloj)
                const Text('Numero de intentos'),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextField(
                    // Utilizamos el controlador de intentos
                    controller: _intentosController,
                    decoration: const InputDecoration(
                      hintText: 'Numero de intentos',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 20),
                // Pedimos contador de tiempo (en ms para poder hacer la conversión después)
                const Text('Contador de tiempo (en ms)'),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextField(
                    // Su respectivo controlador
                    controller: _tiempoController,
                    decoration: const InputDecoration(
                      hintText: 'Contador de tiempo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text(
                  '(Configurar también para modo contrarreloj)',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                // Oportundades o tokens de pausa
                const Text('Oportunidades de pausa'),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextField(
                    // Su respectivo controlador
                    controller: _pausaController,
                    decoration: const InputDecoration(
                      hintText: 'Oportunidades de pausa',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text(
                  '(Configurar también para modo contrarreloj)',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                    // Este botón iniciará el juego personalizado
                    onPressed: () {
                      // Utilizará los mismos métodos del modo contrarreloj, pero acá se asigna un valor en vIntentos
                      vIntentos = int.tryParse(_intentosController.text) ?? 0;
                      vTiempo = int.tryParse(_tiempoController.text) ?? 0;
                      vPausa = int.tryParse(_pausaController.text) ?? 0;
                      Provider.of<CounterProvider>(context, listen: false)
                          .actualizarIntentos(vIntentos);
                      Provider.of<CounterProvider>(context, listen: false)
                          .actualizarTiempo(vTiempo);
                      Provider.of<CounterProvider>(context, listen: false)
                          .actualizarPausa(vPausa);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // Redirigimos a Juego
                              // Redirigo a la misma vista que el juego default
                              // Me dí cuenta que lo que estaba haciendo en un principio cuando desarrollé el juego general servía para este
                              builder: (context) => Juego(
                                    // Uso de vIntentos para juego personalizado
                                    intentos: vIntentos,
                                    tiempo: vTiempo,
                                    pausa: vPausa,
                                    modo: modo,
                                  )
                                )
                              );
                    },
                    child: const Text('Empezar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
