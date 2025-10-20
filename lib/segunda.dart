import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'profile.dart';
import 'qrCode.dart';

class SegundaPage extends StatelessWidget {
  const SegundaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TOPO com gradiente
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
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
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "SEGUNDA",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
  Image.asset(
                  'assets/images/Imagem.png', // caminho da sua logo
                  width: 100,
                  height: 100,
              fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // CONTEÚDO DO CARDÁPIO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: const [
                  _Section(
                    title: "Café da Manhã",
                    items: ["Arroz - Feijão", "Carne com cenoura beterraba"],
                  ),
                  _Section(
                    title: "Almoço",
                    items: ["Pão com manteiga", "Café com leite"],
                  ),
                  _Section(
                    title: "Lanche da Tarde",
                    items: ["Arroz - Feijão", "Carne com cenoura beterraba"],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Rodapé padronizado
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
  onPressed: () async {
    // 1️⃣ Pega o e-mail salvo no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('usuarioEmail');

    // 2️⃣ Navega para a tela de Profile passando o e-mail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(email: email ?? ''),
      ),
    );
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
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Qrcode()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget reutilizável para cada seção
class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                e,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
