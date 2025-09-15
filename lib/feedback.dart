import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/desperdicio_zero.dart';
import 'package:navegacao_entre_telas/main.dart';

// Tela de agradecimento
class ObrigadoPage extends StatefulWidget {
  const ObrigadoPage({super.key});

  @override
  State<ObrigadoPage> createState() => _ObrigadoPageState();
}

class _ObrigadoPageState extends State<ObrigadoPage> {
  @override
  void initState() {
    super.initState();

    // Timer de 3 segundos antes de redirecionar
 Timer(const Duration(seconds: 3), () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomeScreen(), // classe principal do main.dart
    ),
  );
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone circular central
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),

            // Texto "Obrigado pelo feedback!"
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: const Text(
                "Obrigado pelo feedback!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Exemplo de HomeScreen (onde o app redireciona)
