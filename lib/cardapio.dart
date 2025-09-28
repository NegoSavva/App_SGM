import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/main.dart';
import 'package:navegacao_entre_telas/profile.dart';
import 'package:navegacao_entre_telas/qrCode.dart';
import 'package:navegacao_entre_telas/quarta.dart';
import 'package:navegacao_entre_telas/quinta.dart';
import 'package:navegacao_entre_telas/segunda.dart';
import 'package:navegacao_entre_telas/sexta.dart';
import 'package:navegacao_entre_telas/terca.dart';

class CardapioPage extends StatelessWidget {
  const CardapioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada com gradiente
      body: Column(
        children: [
          // Cabeçalho unificado
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
                  Positioned(
                    left: 10,
                    top: 15,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      "CARDÁPIO",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 10,
                    child: Image.asset(
                      'assets/images/fiebof.png',
                      height: 90, // tamanho ajustado para caber melhor
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botões dos dias da semana
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildDayButton(context, "SEGUNDA", const SegundaPage()),
                _buildDayButton(context, "TERÇA", const TerceiraPage()),
                _buildDayButton(context, "QUARTA", const quartaPage()),
                _buildDayButton(context, "QUINTA", const quintaPage()),
                _buildDayButton(context, "SEXTA", const SextaPage()),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
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
                      context, MaterialPageRoute(builder: (_) => Profile()));
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
                      context, MaterialPageRoute(builder: (_) => Qrcode()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Função para criar os botões dos dias
Widget _buildDayButton(BuildContext context, String text, Widget page) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 4,
        shadowColor: Colors.black38,
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}
