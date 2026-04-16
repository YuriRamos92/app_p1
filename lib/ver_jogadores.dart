import 'package:flutter/material.dart';
import 'cadastro_jogador.dart';

class TelaVerJogadores extends StatefulWidget {
  const TelaVerJogadores({super.key});

  @override
  State<TelaVerJogadores> createState() => _TelaVerJogadoresState();
}

class _TelaVerJogadoresState extends State<TelaVerJogadores> {
  void excluirJogador(int index) {
    setState(() {
      jogadores.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jogador removido'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void editarJogador(int index) {
    final nomeController = TextEditingController(
      text: jogadores[index]['nome'],
    );
    final cpfController = TextEditingController(text: jogadores[index]['cpf']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar jogador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  jogadores[index]['nome'] = nomeController.text.trim();
                  jogadores[index]['cpf'] = cpfController.text.trim();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Jogador atualizado'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: jogadores.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum jogador cadastrado.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Lista de jogadores',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: jogadores.length,
                          itemBuilder: (context, index) {
                            final jogador = jogadores[index];

                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(jogador['nome'] ?? ''),
                                subtitle: Text('CPF: ${jogador['cpf'] ?? ''}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        editarJogador(index);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        excluirJogador(index);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
    );
  }
}
