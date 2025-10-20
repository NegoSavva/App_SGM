import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/cardapio.dart';
import 'package:navegacao_entre_telas/desperdicio_zero.dart';
import 'package:navegacao_entre_telas/form1.dart';
import 'package:navegacao_entre_telas/profile.dart';
import 'package:navegacao_entre_telas/qrCode.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginAnimationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// ============================
/// Tela de Login
/// ============================
class LoginAnimationPage extends StatefulWidget {
  const LoginAnimationPage({super.key});

  @override
  State<LoginAnimationPage> createState() => _LoginAnimationPageState();
}

class _LoginAnimationPageState extends State<LoginAnimationPage> {
  bool _showLogin = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLogin = true;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      // 🔹 Guarda o e-mail em memória temporária
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuarioEmail', email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/cod.png', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          Center(
            child: Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: _showLogin ? 0 : -height,
            height: height * 0.6,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe seu e-mail';
                          } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                              .hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe sua senha';
                          } else if (value.length < 6) {
                            return 'A senha deve ter ao menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// Tela Principal (HomeScreen)
/// ============================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? emailUsuario;

  @override
  void initState() {
    super.initState();
    _carregarEmail();
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailUsuario = prefs.getString('usuarioEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Cabeçalho
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bem-vindo, ${emailUsuario ?? "USER"}!",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Aba inicial",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/Imagem.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Lista de atalhos
          Expanded(
            child: ListView(
              children: [
                _buildShortcut(
                  icon: Icons.tour,
                  color: Colors.brown,
                  title: "Nossa ODS",
                  subtitle: "Descrição",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DesperdicioZeroPage()),
                    );
                  },
                ),
                _buildShortcut(
                  icon: Icons.restaurant_menu,
                  color: Colors.red,
                  title: "Cardápio",
                  subtitle: "Descritivo dos dias",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CardapioPage()),
                    );
                  },
                ),
                _buildShortcut(
                  icon: Icons.article,
                  color: Colors.blue,
                  title: "Formulário",
                  subtitle: "Feedback Geral",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AvaliacaoPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
  onPressed: () async {
    // Pega o e-mail salvo no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('usuarioEmail');

    // Abre a tela de Profile passando o e-mail
    Navigator.pushReplacement(
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
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Qrcode()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcut({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
