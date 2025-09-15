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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false, // seta padrão desativada
          flexibleSpace: Container(
            padding: const EdgeInsets.only(
              top: 30, // 🔹 diminuí o padding para não "esconder" a seta
              left: 8,
              right: 8,
              bottom: 10,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6BA4F8), Color(0xFFB3D2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
                Image.asset(
                  'assets/images/fiebof.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
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
