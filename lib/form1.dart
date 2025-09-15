import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/form2.dart';
import 'package:navegacao_entre_telas/main.dart';

class AvaliacaoPage extends StatefulWidget {
  const AvaliacaoPage({super.key});

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  String? opcaoSelecionada;

  final List<String> opcoes = [
    "Excelente",
    "Bom",
    "Regular",
    "Ruim",
    "Péssimo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de progresso com seta de voltar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                     onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Pergunta
              const Text(
                "Como você classificaria a qualidade da nossa comida?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Opções
              ...opcoes.map(
                (opcao) => CheckboxListTile(
                  title: Text(opcao),
                  value: opcaoSelecionada == opcao,
                  onChanged: (_) {
                    setState(() {
                      opcaoSelecionada = opcao;
                    });
                  },
                ),
              ),

              const Spacer(),

              // Botão Próximo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: opcaoSelecionada == null
                        ? Colors.grey
                        : Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: opcaoSelecionada == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AvaliacaoQrPage2(),
                            ),
                          );
                        },
                  child: const Text(
                    "Próximo",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
