import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/profile.dart';
import 'package:navegacao_entre_telas/qrCode.dart';
import 'package:navegacao_entre_telas/qrcodeinfo.dart';
import 'main.dart';
import 'qrcode.dart'; // certifique-se de importar a tela de QR code

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DesperdicioZeroPage(),
    );
  }
}

class DesperdicioZeroPage extends StatelessWidget {
  const DesperdicioZeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 CABEÇALHO UNIFICADO (substitui o AppBar anterior)
      body: Column(
        children: [
         Container(
  height: 120,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  decoration: const BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25),
    ),
    gradient: LinearGradient(
      colors: [Color(0xFF6BA4F8), Color(0xFFB3D2FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: SafeArea(
    child: Stack(
      children: [
        // Botão de voltar à esquerda
        Positioned(
          left: 10,
          top: 15,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ),
        // Logo à direita
        Positioned(
          right: 10,
          top: 15,
          child: Image.asset(
            'assets/images/Imagem.png',
            width: 100,
            height: 100,
          ),
        ),
      ],
    ),
  ),
),


          // 🔹 CONTEÚDO PRINCIPAL
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "DESPERDÍCIO",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    "ZERO",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/ODS-12-2.webp',
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "A comida que jogamos fora representa não só recursos preciosos desperdiçados, "
                      "mas também a negação de alimento a alguém mais necessitado. Devemos lembrar "
                      "que cada mordida que não consumimos tem um custo - um custo para o meio ambiente, "
                      "para nossa consciência e para aqueles que lutam para colocar comida em suas mesas.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔹 BARRA DE NAVEGAÇÃO INFERIOR
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Profile()));
                },
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeScreen()));
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const QrcodeInfoPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
