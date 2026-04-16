import 'package:flutter/material.dart';
import 'cadastro_jogador.dart';

class TelaRanking extends StatelessWidget {
  const TelaRanking({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ranking = List.from(jogadores);

    ranking.sort((a, b) => (b['pontos'] ?? 0).compareTo(a['pontos'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
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
            child: ranking.isEmpty
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
                        'Classificação',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ranking.length,
                          itemBuilder: (context, index) {
                            final jogador = ranking[index];

                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(jogador['nome']),
                                subtitle: Text('CPF: ${jogador['cpf']}'),
                                trailing: Text(
                                  '${jogador['pontos']} pts',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
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
