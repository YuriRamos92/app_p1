import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> jogadores = [];

Future<void> carregarJogadores() async {
  jogadores.clear();

  final resultado = await FirebaseFirestore.instance
      .collection('jogadores')
      .get();

  for (var doc in resultado.docs) {
    final dados = doc.data();

    jogadores.add({
      'id': doc.id,
      'nome': dados['nome'] ?? '',
      'telefone': dados['telefone'] ?? '',
      'pontos': dados['pontos'] ?? 0,
    });
  }
}

class TelaCadastroJogador extends StatefulWidget {
  const TelaCadastroJogador({super.key});

  @override
  State<TelaCadastroJogador> createState() => _TelaCadastroJogadorState();
}

class _TelaCadastroJogadorState extends State<TelaCadastroJogador> {
  final nomeController = TextEditingController();

  final telefoneController = TextEditingController();

  Future<void> cadastrarJogador() async {
    final nome = nomeController.text.trim();

    final telefone = telefoneController.text.trim();

    if (nome.isEmpty || telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('jogadores').add({
        'nome': nome,
        'telefone': telefone,
        'pontos': 0,
      });

      jogadores.add({
        'id': doc.id,
        'nome': nome,
        'telefone': telefone,
        'pontos': 0,
      });

      nomeController.clear();
      telefoneController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jogador cadastrado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Jogador'),
        centerTitle: true,
        backgroundColor: const Color(0xFFC9A227),
        foregroundColor: Colors.black,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/pikachu.png'),
            fit: BoxFit.cover,

            colorFilter: ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.2),
              BlendMode.darken,
            ),
          ),
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFFF8F4E8),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  const Icon(
                    Icons.person_add,
                    size: 70,
                    color: Color(0xFFC9A227),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Cadastro de Jogadores',

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Adicione novos jogadores ao torneio',

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nomeController,

                    decoration: const InputDecoration(
                      labelText: 'Nome',

                      border: OutlineInputBorder(),

                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: telefoneController,

                    keyboardType: TextInputType.phone,

                    decoration: const InputDecoration(
                      labelText: 'Telefone',

                      border: OutlineInputBorder(),

                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: cadastrarJogador,

                    icon: const Icon(Icons.save),

                    label: const Text('Cadastrar'),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A227),

                      foregroundColor: Colors.black,

                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back),

                    label: const Text('Voltar'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C4324),

                      side: const BorderSide(
                        color: Color(0xFF5C4324),
                        width: 2,
                      ),

                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
