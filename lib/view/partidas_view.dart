import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adicionar_jogadores_view.dart';

class TelaSortearPartidas extends StatefulWidget {
  const TelaSortearPartidas({super.key});

  @override
  State<TelaSortearPartidas> createState() => _TelaSortearPartidasState();
}

class _TelaSortearPartidasState extends State<TelaSortearPartidas> {
  List<Map<String, dynamic>> jogadoresSorteados = [];
  List<Map<String, dynamic>> partidas = [];
  Map<int, int> vencedoresSelecionados = {};
  List<String> confrontosAnteriores = [];
  Map<String, dynamic>? jogadorBye;
  bool resultadosConfirmados = false;
  bool salvandoResultados = false;

  @override
  void initState() {
    super.initState();
    sortearPartidas();
  }

  String _identificadorJogador(Map<String, dynamic> jogador) {
    return (jogador['id'] ?? jogador['telefone'] ?? jogador['nome'] ?? '')
        .toString();
  }

  Future<void> _atualizarPontosFirestore(
    Map<String, dynamic> jogador,
    int pontos,
  ) async {
    try {
      if (jogador['id'] != null && jogador['id'].toString().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('jogadores')
            .doc(jogador['id'])
            .update({'pontos': FieldValue.increment(pontos)});
        return;
      }

      if (jogador['telefone'] != null &&
          jogador['telefone'].toString().isNotEmpty) {
        final query = await FirebaseFirestore.instance
            .collection('jogadores')
            .where('telefone', isEqualTo: jogador['telefone'])
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          await query.docs.first.reference.update({
            'pontos': FieldValue.increment(pontos),
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao atualizar pontos de ${jogador['nome']}: $e');
      rethrow;
    }
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

    while (jogadoresSorteados.isNotEmpty) {
      final jogador1 = jogadoresSorteados.removeAt(0);

      int indiceOponente = jogadoresSorteados.indexWhere((jogador2) {
        final id1 = _identificadorJogador(jogador1);
        final id2 = _identificadorJogador(jogador2);

        final confronto1 = '$id1-$id2';
        final confronto2 = '$id2-$id1';

        return !confrontosAnteriores.contains(confronto1) &&
            !confrontosAnteriores.contains(confronto2);
      });

      if (indiceOponente == -1) {
        indiceOponente = 0;
      }

      final jogador2 = jogadoresSorteados.removeAt(indiceOponente);

      partidas.add({'jogador1': jogador1, 'jogador2': jogador2});
    }

    setState(() {});
  }

  Future<void> confirmarResultados() async {
    if (salvandoResultados) return;

    if (partidas.isNotEmpty &&
        vencedoresSelecionados.length < partidas.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escolha o resultado de todas as partidas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      salvandoResultados = true;
    });

    try {
      for (int i = 0; i < partidas.length; i++) {
        final resultado = vencedoresSelecionados[i]!;
        final jogador1 = partidas[i]['jogador1'] as Map<String, dynamic>;
        final jogador2 = partidas[i]['jogador2'] as Map<String, dynamic>;

        final id1 = _identificadorJogador(jogador1);
        final id2 = _identificadorJogador(jogador2);

        confrontosAnteriores.add('$id1-$id2');

        if (resultado == 1) {
          jogador1['pontos'] = (jogador1['pontos'] ?? 0) + 3;
          await _atualizarPontosFirestore(jogador1, 3);
        } else if (resultado == 2) {
          jogador2['pontos'] = (jogador2['pontos'] ?? 0) + 3;
          await _atualizarPontosFirestore(jogador2, 3);
        } else if (resultado == 0) {
          jogador1['pontos'] = (jogador1['pontos'] ?? 0) + 1;
          jogador2['pontos'] = (jogador2['pontos'] ?? 0) + 1;

          await _atualizarPontosFirestore(jogador1, 1);
          await _atualizarPontosFirestore(jogador2, 1);
        }
      }

      if (jogadorBye != null) {
        jogadorBye!['pontos'] = (jogadorBye!['pontos'] ?? 0) + 3;
        await _atualizarPontosFirestore(jogadorBye!, 3);
      }

      if (!mounted) return;

      setState(() {
        resultadosConfirmados = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rodada finalizada e pontos atualizados!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar resultados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvandoResultados = false;
        });
      }
    }
  }

  Widget cardPartida(int index) {
    final jogador1 = partidas[index]['jogador1'];
    final jogador2 = partidas[index]['jogador2'];
    final vencedorEscolhido = vencedoresSelecionados[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${jogador1['nome']}  VS  ${jogador2['nome']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: resultadosConfirmados || salvandoResultados
                ? null
                : () {
                    setState(() {
                      vencedoresSelecionados[index] = 1;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: vencedorEscolhido == 1
                  ? Colors.green
                  : const Color(0xFFC9A227),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(jogador1['nome']),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: resultadosConfirmados || salvandoResultados
                ? null
                : () {
                    setState(() {
                      vencedoresSelecionados[index] = 0;
                    });
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange, width: 2),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Empate'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: resultadosConfirmados || salvandoResultados
                ? null
                : () {
                    setState(() {
                      vencedoresSelecionados[index] = 2;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: vencedorEscolhido == 2
                  ? Colors.green
                  : const Color(0xFFC9A227),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
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
                  const Icon(Icons.casino, size: 70, color: Color(0xFFC9A227)),
                  const SizedBox(height: 10),
                  const Text(
                    'Partidas Sorteadas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Escolha os vencedores da rodada',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  if (jogadorBye != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${jogadorBye!['nome']} ficou sem partida nesta rodada.\n(+3 pontos)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  partidas.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Não há jogadores suficientes.'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: partidas.length,
                          itemBuilder: (context, index) {
                            return cardPartida(index);
                          },
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: resultadosConfirmados || salvandoResultados
                        ? null
                        : confirmarResultados,
                    icon: salvandoResultados
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      salvandoResultados
                          ? 'Salvando resultados...'
                          : 'Confirmar resultados',
                    ),
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
                    onPressed: salvandoResultados ? null : sortearPartidas,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Sortear novamente'),
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
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: salvandoResultados
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Voltar',
                      style: TextStyle(color: Color(0xFF5C4324)),
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
