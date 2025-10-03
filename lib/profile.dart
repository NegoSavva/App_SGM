import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // para detectar Web
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:navegacao_entre_telas/qrCode.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController aniversarioController = TextEditingController();

  File? _profileImageFile;       // usado em Android/iOS/PC
  Uint8List? _profileImageBytes; // usado em Web

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
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    nomeController.text = prefs.getString('nome') ?? '';
    aniversarioController.text = prefs.getString('aniversario') ?? '';

    final savedCurso = prefs.getString('curso');
    cursoSelecionado =
        (savedCurso != null && cursos.contains(savedCurso)) ? savedCurso : null;

    final savedTurma = prefs.getString('turma');
    turmaSelecionada =
        (savedTurma != null && turmas.contains(savedTurma)) ? savedTurma : null;

    final savedSerie = prefs.getInt('serie');
    serieSelecionada =
        (savedSerie != null && series.contains(savedSerie)) ? savedSerie : null;

    final savedPeriodo = prefs.getString('periodo');
    periodoSelecionado = (savedPeriodo != null && periodos.contains(savedPeriodo))
        ? savedPeriodo
        : null;

    // Carregar imagem salva
    if (kIsWeb) {
      final base64Image = prefs.getString('profile_image_web');
      if (base64Image != null) {
        setState(() {
          _profileImageBytes = base64Decode(base64Image);
        });
      }
    } else {
      final imagePath = prefs.getString('profile_image');
      if (imagePath != null && File(imagePath).existsSync()) {
        setState(() {
          _profileImageFile = File(imagePath);
        });
      }
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nomeController.text);
    await prefs.setString('aniversario', aniversarioController.text);
    if (cursoSelecionado != null) {
      await prefs.setString('curso', cursoSelecionado!);
    }
    if (turmaSelecionada != null) {
      await prefs.setString('turma', turmaSelecionada!);
    }
    if (serieSelecionada != null) {
      await prefs.setInt('serie', serieSelecionada!);
    }
    if (periodoSelecionado != null) {
      await prefs.setString('periodo', periodoSelecionado!);
    }

    if (kIsWeb && _profileImageBytes != null) {
      String base64Image = base64Encode(_profileImageBytes!);
      await prefs.setString('profile_image_web', base64Image);
    } else if (_profileImageFile != null) {
      await prefs.setString('profile_image', _profileImageFile!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alterações salvas!')),
    );
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            const Text(
              "RM00000@estudante.fieb.edu.br",
              style: TextStyle(color: Colors.grey),
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
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: cursoSelecionado,
                      decoration: InputDecoration(
                        labelText: "Curso",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: cursos
                          .map((curso) => DropdownMenuItem(
                                value: curso,
                                child: Text(curso),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => cursoSelecionado = val),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: turmaSelecionada,
                      decoration: InputDecoration(
                        labelText: "Turma",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: turmas
                          .map((turma) => DropdownMenuItem(
                                value: turma,
                                child: Text(turma),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => turmaSelecionada = val),
                    ),
                  ),
                ],
              ),
            ),

            // Série e Período
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: serieSelecionada,
                      decoration: InputDecoration(
                        labelText: "Série",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: series
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.toString()),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => serieSelecionada = val),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: periodoSelecionado,
                      decoration: InputDecoration(
                        labelText: "Período",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: periodos
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => periodoSelecionado = val),
                    ),
                  ),
                ],
              ),
            ),

            // Aniversário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: aniversarioController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Aniversário",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2006, 8, 12),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          aniversarioController.text =
                              "${pickedDate.day.toString().padLeft(2, '0')}/"
                              "${pickedDate.month.toString().padLeft(2, '0')}/"
                              "${pickedDate.year}";
                        });
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão salvar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: const Text("Salvar alterações"),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Você já está na tela de usuário.'),
                      duration: Duration(seconds: 2),
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
