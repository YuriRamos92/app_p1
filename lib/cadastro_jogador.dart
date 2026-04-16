import 'package:flutter/material.dart';

List<Map<String, dynamic>> jogadores = [
  {'nome': 'Bruno', 'cpf': '11111111111', 'pontos': 0},
  {'nome': 'Fernando', 'cpf': '22222222222', 'pontos': 0},
  {'nome': 'Rodrigo', 'cpf': '33333333333', 'pontos': 0},
  {'nome': 'Guilherme', 'cpf': '44444444444', 'pontos': 0},
  {'nome': 'Sabrina', 'cpf': '55555555555', 'pontos': 0},
  {'nome': 'Letícia', 'cpf': '66666666666', 'pontos': 0},
  {'nome': 'Erika', 'cpf': '77777777777', 'pontos': 0},
];

class TelaCadastroJogador extends StatefulWidget {
  const TelaCadastroJogador({super.key});

  @override
  State<TelaCadastroJogador> createState() => _TelaCadastroJogadorState();
}

class _TelaCadastroJogadorState extends State<TelaCadastroJogador> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  void cadastrarJogador() {
    final nome = nomeController.text.trim();
    final cpf = cpfController.text.trim();

    if (nome.isEmpty || cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha nome e CPF'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    jogadores.add({'nome': nome, 'cpf': cpf, 'pontos': 0});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jogador cadastrado!'),
        backgroundColor: Colors.green,
      ),
    );

    nomeController.clear();
    cpfController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Jogador'),
        backgroundColor: Colors.amber,
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
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person, size: 60, color: Colors.amber),
                  const SizedBox(height: 10),
                  const Text(
                    'Novo Jogador',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                    controller: cpfController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cadastrarJogador,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cadastrar'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Voltar',
                      style: TextStyle(color: Colors.black),
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
