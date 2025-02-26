import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'options_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gif(
              image: const AssetImage("images/welcome.gif"),
              autostart: Autostart.loop,
            ),
            const Text("Detección y Clasificación de Células en Frotis Sanguíneos", textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
            const SizedBox(height: 20),
            const Text(
              "Nuestra aplicación utiliza inteligencia artificial avanzada con YOLOv8 para identificar y clasificar células en imágenes de frotis de sangre periférica, brindando un apoyo eficiente en el diagnóstico temprano de enfermedades hematológicas.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OptionsScreen()),
                );
              },
              child: const Text("Empezar"),
            ),
          ],
        ),
      ),
    );
  }
}