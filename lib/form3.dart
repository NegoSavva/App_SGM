import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/formfinal.dart';

class AvaliacaoFilaPage3 extends StatefulWidget {
  const AvaliacaoFilaPage3({super.key});

  @override
  State<AvaliacaoFilaPage3> createState() => _AvaliacaoFilaPage3State();
}

class _AvaliacaoFilaPage3State extends State<AvaliacaoFilaPage3> {
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
                      Navigator.pop(context); // volta para a página anterior
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.9, // progresso quase completo
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
                "Como você classificaria o tempo de espera na fila?",
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
                              builder: (context) => const AvaliacaoAppPage(),
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
