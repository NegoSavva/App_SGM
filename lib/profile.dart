import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navegacao_entre_telas/qrCode.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  final String? email;

  const Profile({super.key, required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController aniversarioController = TextEditingController();

  File? _profileImageFile;
  Uint8List? _profileImageBytes;

  String? cursoSelecionado;
  String? turmaSelecionada;
  int? serieSelecionada;
  String? periodoSelecionado;

  final List<String> cursos = [
    'Edificações',
    'Eletroeletrônica',
    'Informática',
    'Informática p Internet',
    'Redes de Computadores',
    'Telecomunicações',
  ];

  final List<String> turmas = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  final List<int> series = [1, 2, 3];
  final List<String> periodos = ['Manhã', 'Tarde', 'Noite'];

  @override
  void initState() {
    super.initState();
    _carregarDadosPorEmail();
  }

  void _carregarDadosPorEmail() {
    // 🔹 Lógica para alterar as informações conforme o e-mail do login
    if (widget.email == 'RM90322@estudante.fieb.edu.br') {
      nomeController.text = "João Vitor Macena Nicolay";
      aniversarioController.text = "06/06/2007";
      cursoSelecionado = "Informática";
      turmaSelecionada = "C";
      serieSelecionada = 3;
      periodoSelecionado = "Manhã";
    } else if (widget.email == 'RM90309@estudante.fieb.edu.br') {
      nomeController.text = "Gustavo Ferreira dos Santos Primo";
      aniversarioController.text = "31/03/2008";
      cursoSelecionado = "Informática";
      turmaSelecionada = "C";
      serieSelecionada = 3;
      periodoSelecionado = "Manhã";
    } else {
      nomeController.text = "Usuário Desconhecido";
      aniversarioController.text = "--/--/----";
      cursoSelecionado = "Informática";
      turmaSelecionada = "A";
      serieSelecionada = 1;
      periodoSelecionado = "Manhã";
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          _profileImageBytes = result.files.first.bytes;
        });
      } else {
        if (result.files.single.path != null) {
          setState(() {
            _profileImageFile = File(result.files.single.path!);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;

    if (_profileImageFile != null) {
      avatarImage = FileImage(_profileImageFile!);
    } else if (_profileImageBytes != null) {
      avatarImage = MemoryImage(_profileImageBytes!);
    } else {
      avatarImage = const AssetImage('assets/images/Default_pfp.jpg');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6BA4F8), Color(0xFFB3D2FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                            );
                          },
                        ),
                        Image.asset(
                          'assets/images/Imagem.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -75,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: avatarImage,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 90),

            const Text(
              "Nome",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.email ?? "",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Nome
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: buildTextField("Nome completo", nomeController),
            ),

            // Curso e Turma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.maxWidth < 400
                      ? Column(
                          children: [
                            buildDropdown("Curso", cursoSelecionado, cursos),
                            const SizedBox(height: 10),
                            buildDropdown("Turma", turmaSelecionada, turmas),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                                child: buildDropdown(
                                    "Curso", cursoSelecionado, cursos)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: buildDropdown(
                                    "Turma", turmaSelecionada, turmas)),
                          ],
                        );
                },
              ),
            ),

            // Série e Período
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: buildDropdownInt(
                          "Série", serieSelecionada, series)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: buildDropdown(
                          "Período", periodoSelecionado, periodos)),
                ],
              ),
            ),

            // Data de nascimento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: aniversarioController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Data de nascimento",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // 🔹 Barra inferior com correção do parâmetro
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
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('usuarioEmail'); // pega o e-mail salvo
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

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildDropdown(
      String label, String? valor, List<String> opcoes) {
    return DropdownButtonFormField<String>(
      value: valor,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: opcoes
          .map((op) => DropdownMenuItem(
                value: op,
                child: Text(op),
              ))
          .toList(),
      onChanged: null,
    );
  }

  Widget buildDropdownInt(
      String label, int? valor, List<int> opcoes) {
    return DropdownButtonFormField<int>(
      value: valor,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: opcoes
          .map((op) => DropdownMenuItem(
                value: op,
                child: Text(op.toString()),
              ))
          .toList(),
      onChanged: null,
    );
  }
}
