import 'dart:math';
import 'package:flutter/material.dart';
import 'cadastro_jogador.dart';

class TelaSortearPartidas extends StatefulWidget {
  const TelaSortearPartidas({super.key});

  @override
  State<TelaSortearPartidas> createState() => _TelaSortearPartidasState();
}

class _TelaSortearPartidasState extends State<TelaSortearPartidas> {
  List<Map<String, dynamic>> jogadoresSorteados = [];
  List<Map<String, dynamic>> partidas = [];
  Map<int, int> vencedoresSelecionados = {};
  Map<String, dynamic>? jogadorBye;
  bool resultadosConfirmados = false;

  @override
  void initState() {
    super.initState();
    sortearPartidas();
  }

  void sortearPartidas() {
    jogadoresSorteados = List<Map<String, dynamic>>.from(jogadores);
    jogadoresSorteados.shuffle(Random());

    partidas.clear();
    vencedoresSelecionados.clear();
    jogadorBye = null;
    resultadosConfirmados = false;

    if (jogadoresSorteados.length.isOdd) {
      jogadorBye = jogadoresSorteados.removeLast();
    }

    for (int i = 0; i < jogadoresSorteados.length; i += 2) {
      partidas.add({
        'jogador1': jogadoresSorteados[i],
        'jogador2': jogadoresSorteados[i + 1],
      });
    }

    setState(() {});
  }

  void confirmarResultados() {
    if (partidas.isNotEmpty &&
        vencedoresSelecionados.length < partidas.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escolha um vencedor para cada partida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (int i = 0; i < partidas.length; i++) {
      int vencedor = vencedoresSelecionados[i]!;

      if (vencedor == 1) {
        partidas[i]['jogador1']['pontos'] =
            (partidas[i]['jogador1']['pontos'] ?? 0) + 1;
      } else {
        partidas[i]['jogador2']['pontos'] =
            (partidas[i]['jogador2']['pontos'] ?? 0) + 1;
      }
    }

    if (jogadorBye != null) {
      jogadorBye!['pontos'] = (jogadorBye!['pontos'] ?? 0) + 1;
    }

    setState(() {
      resultadosConfirmados = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rodada finalizada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget cardPartida(int index) {
    final jogador1 = partidas[index]['jogador1'];
    final jogador2 = partidas[index]['jogador2'];

    final vencedorEscolhido = vencedoresSelecionados[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text(
            '${jogador1['nome']} x ${jogador2['nome']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: resultadosConfirmados
                ? null
                : () {
                    setState(() {
                      vencedoresSelecionados[index] = 1;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: vencedorEscolhido == 1
                  ? Colors.green
                  : Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: Text(jogador1['nome']),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: resultadosConfirmados
                ? null
                : () {
                    setState(() {
                      vencedoresSelecionados[index] = 2;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: vencedorEscolhido == 2
                  ? Colors.green
                  : Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: Text(jogador2['nome']),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sortear Partidas'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Partidas sorteadas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (jogadorBye != null)
                  Text(
                    '${jogadorBye!['nome']} ficou sem partida nesta rodada.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: partidas.isEmpty
                      ? const Center(
                          child: Text('Não há jogadores suficientes.'),
                        )
                      : ListView.builder(
                          itemCount: partidas.length,
                          itemBuilder: (context, index) {
                            return cardPartida(index);
                          },
                        ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: resultadosConfirmados ? null : confirmarResultados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Confirmar resultados'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: sortearPartidas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Sortear novamente'),
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
    );
  }
}
