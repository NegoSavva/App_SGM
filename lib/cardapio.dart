import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:navegacao_entre_telas/main.dart';
import 'package:navegacao_entre_telas/profile.dart';
import 'package:navegacao_entre_telas/qrCode.dart';

/// Modelo para PratoDTO
class PratoDTO {
  final int? id;
  final String? nome;
  final String? descricao;
  final String? principal;
  final String? secundario;
  final String? acompanhamento;
  final String? statusPrato;

  PratoDTO({
    this.id,
    this.nome,
    this.descricao,
    this.principal,
    this.secundario,
    this.acompanhamento,
    this.statusPrato,
  });

  factory PratoDTO.fromJson(Map<String, dynamic> json) {
    return PratoDTO(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      principal: json['principal'],
      secundario: json['secundario'],
      acompanhamento: json['acompanhamento'],
      statusPrato: json['statusPrato'],
    );
  }
}

/// Modelo para CardapioDTO
class CardapioDTO {
  final int? id;
  final String? nome;
  final String? diaServido;
  final String? statusCardapio;
  final String? fotoBase64;
  final PratoDTO? prato;

  CardapioDTO({
    this.id,
    this.nome,
    this.diaServido,
    this.statusCardapio,
    this.fotoBase64,
    this.prato,
  });

  factory CardapioDTO.fromJson(Map<String, dynamic> json) {
    return CardapioDTO(
      id: json['id'],
      nome: json['nome'],
      diaServido: json['diaServido'],
      statusCardapio: json['statusCardapio'],
      fotoBase64: json['foto'],
      prato: json['prato'] != null ? PratoDTO.fromJson(json['prato']) : null,
    );
  }
}

/// Função para buscar todos os cardápios ativos
Future<List<CardapioDTO>> fetchCardapiosAtivos() async {
  final url = Uri.parse('http://10.0.2.2:8080/cardapio/findAllAtivos');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => CardapioDTO.fromJson(e)).toList();
  } else {
    throw Exception('Falha ao carregar cardápios');
  }
}

/// Função para buscar cardápio por nome
Future<List<CardapioDTO>> fetchCardapiosPorNome(String nome) async {
  final url = Uri.parse('http://10.0.2.2:8080/cardapio/findByNome?nome=$nome');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => CardapioDTO.fromJson(e)).toList();
  } else {
    throw Exception('Erro ao buscar cardápio pelo nome');
  }
}

/// Tela principal do Cardápio
class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  late Future<List<CardapioDTO>> _futureCardapios;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _futureCardapios = fetchCardapiosAtivos();
  }

  void _buscarCardapios() {
    setState(() {
      final nome = _searchController.text.trim();
      if (nome.isEmpty) {
        _isSearching = false;
        _futureCardapios = fetchCardapiosAtivos();
      } else {
        _isSearching = true;
        _futureCardapios = fetchCardapiosPorNome(nome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Cabeçalho
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
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                      'assets/images/Imagem.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Campo de busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar cardápio pelo nome...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _buscarCardapios(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black87),
                  onPressed: () {
                    _searchController.clear();
                    _buscarCardapios();
                  },
                ),
              ],
            ),
          ),

          /// Lista de cardápios
          Expanded(
            child: FutureBuilder<List<CardapioDTO>>(
              future: _futureCardapios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      _isSearching
                          ? 'Nenhum cardápio encontrado.'
                          : 'Nenhum cardápio ativo disponível.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  final cardapios = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cardapios.length,
                    itemBuilder: (context, index) {
                      final cardapio = cardapios[index];
                      return _buildCardapioCard(context, cardapio);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

      /// Bottom Navigation
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
                    context,
                    MaterialPageRoute(builder: (_) => Profile()),
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
                    MaterialPageRoute(builder: (_) => Qrcode()),
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

/// Componente para exibir cada cardápio com todos os dados do prato
Widget _buildCardapioCard(BuildContext context, CardapioDTO cardapio) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Nome e dia
          Text(
            cardapio.nome ?? 'Sem nome',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (cardapio.diaServido != null)
            Text("📅 Dia servido: ${cardapio.diaServido}"),
          if (cardapio.statusCardapio != null)
            Text(
              "🍽️ Status: ${cardapio.statusCardapio}",
              style: TextStyle(
                color: cardapio.statusCardapio == 'ATIVO'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          const SizedBox(height: 8),

          /// Foto do cardápio
          if (cardapio.fotoBase64 != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(cardapio.fotoBase64!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),

          /// Dados do prato
          if (cardapio.prato != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("🍽️ Prato: ${cardapio.prato!.nome ?? 'Sem nome'}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Descrição: ${cardapio.prato!.descricao ?? 'Sem descrição'}"),
                Text("Principal: ${cardapio.prato!.principal ?? 'Não informado'}"),
                Text("Secundário: ${cardapio.prato!.secundario ?? 'Não informado'}"),
                Text("Acompanhamento: ${cardapio.prato!.acompanhamento ?? 'Não informado'}"),
                Text("Status do Prato: ${cardapio.prato!.statusPrato ?? 'Não informado'}",
                    style: TextStyle(
                      color: cardapio.prato!.statusPrato == 'ATIVO'
                          ? Colors.green
                          : Colors.red,
                    )),
              ],
            ),
        ],
      ),
    ),
  );
}
