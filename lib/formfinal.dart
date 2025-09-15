import 'package:flutter/material.dart';
import 'package:navegacao_entre_telas/feedback.dart';

class AvaliacaoAppPage extends StatefulWidget {
  const AvaliacaoAppPage({super.key});

  @override
  State<AvaliacaoAppPage> createState() => _AvaliacaoAppPageState();
}

class _AvaliacaoAppPageState extends State<AvaliacaoAppPage> {
  int classificacao = 0; // número de estrelas selecionadas
  final TextEditingController comentarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de progresso
              Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1.0, // formulário completo
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
                "Como você classificaria o uso do APP?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Estrelas de avaliação
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < classificacao
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: Colors.blue,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        classificacao = index + 1; // define nota
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Texto "Deixe um comentário"
              const Text(
                "Deixe um comentário",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              // Campo de comentário
              TextField(
                controller: comentarioController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Insira aqui o seu comentário",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const Spacer(),

              // Botão Enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor:
                        classificacao == 0 ? Colors.grey : Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: classificacao == 0
                      ? null
                      : () {
                         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ObrigadoPage(),
          ),
        );
      },
                  child: const Text(
                    "Enviar",
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
