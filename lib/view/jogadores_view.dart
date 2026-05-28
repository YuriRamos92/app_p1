import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'adicionar_jogadores_view.dart';

class TelaVerJogadores extends StatefulWidget {
  const TelaVerJogadores({super.key});

  @override
  State<TelaVerJogadores> createState() => _TelaVerJogadoresState();
}

class _TelaVerJogadoresState extends State<TelaVerJogadores> {
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    iniciar();
  }

  Future<void> iniciar() async {
    setState(() {
      carregando = true;
    });

    await carregarJogadores();

    if (!mounted) return;

    setState(() {
      carregando = false;
    });
  }

  Future<DocumentReference<Map<String, dynamic>>?> _buscarReferenciaJogador(
    Map<String, dynamic> jogador,
  ) async {
    if (jogador['id'] != null && jogador['id'].toString().isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('jogadores')
          .doc(jogador['id']);
    }

    if (jogador['telefone'] != null &&
        jogador['telefone'].toString().isNotEmpty) {
      final query = await FirebaseFirestore.instance
          .collection('jogadores')
          .where('telefone', isEqualTo: jogador['telefone'])
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.reference;
      }
    }

    return null;
  }

  Future<void> excluirJogador(int index) async {
    final jogador = jogadores[index];

    setState(() {
      carregando = true;
    });

    try {
      final docRef = await _buscarReferenciaJogador(jogador);

      if (docRef == null) {
        throw Exception('Jogador não encontrado no Firestore.');
      }

      await docRef.delete();

      if (!mounted) return;

      setState(() {
        jogadores.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jogador removido'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir jogador: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void editarJogador(int index) {
    final nomeController = TextEditingController(
      text: jogadores[index]['nome'],
    );

    final telefoneController = TextEditingController(
      text: jogadores[index]['telefone'],
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Editar jogador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF5C4324)),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final novoNome = nomeController.text.trim();
                final novoTelefone = telefoneController.text.trim();

                if (novoNome.isEmpty || novoTelefone.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha nome e telefone'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                setState(() {
                  carregando = true;
                });

                try {
                  final jogador = jogadores[index];

                  final docRef = await _buscarReferenciaJogador(jogador);

                  if (docRef == null) {
                    throw Exception('Jogador não encontrado no Firestore.');
                  }

                  await docRef.update({
                    'nome': novoNome,
                    'telefone': novoTelefone,
                  });

                  if (!mounted) return;

                  setState(() {
                    jogadores[index]['nome'] = novoNome;
                    jogadores[index]['telefone'] = novoTelefone;
                    jogadores[index]['id'] = docRef.id;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jogador atualizado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao atualizar jogador: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      carregando = false;
                    });
                  }
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9A227),
                foregroundColor: Colors.black,
              ),

              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget cardJogador(int index) {
    final jogador = jogadores[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFC9A227).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.person, color: Color(0xFFC9A227), size: 28),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  jogador['nome'] ?? '',

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Telefone: ${jogador['telefone'] ?? ''}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 4),

                Text(
                  'Pontos: ${jogador['pontos'] ?? 0}',

                  style: const TextStyle(
                    color: Color(0xFF5C4324),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              IconButton(
                onPressed: carregando ? null : () => editarJogador(index),

                icon: const Icon(Icons.edit, color: Color(0xFF5C4324)),
              ),

              IconButton(
                onPressed: carregando ? null : () => excluirJogador(index),

                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        backgroundColor: const Color(0xFFC9A227),
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          Container(
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

                  child: jogadores.isEmpty
                      ? Column(
                          children: const [
                            Icon(
                              Icons.groups,
                              size: 70,
                              color: Color(0xFFC9A227),
                            ),

                            SizedBox(height: 15),

                            Text(
                              'Nenhum jogador cadastrado.',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [
                            const Icon(
                              Icons.groups,
                              size: 70,
                              color: Color(0xFFC9A227),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Lista de Jogadores',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Gerencie os jogadores cadastrados',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 20),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: jogadores.length,

                              itemBuilder: (context, index) {
                                return cardJogador(index);
                              },
                            ),

                            const SizedBox(height: 10),

                            TextButton(
                              onPressed: carregando
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },

                              child: const Text(
                                'Voltar',

                                style: TextStyle(
                                  color: Color(0xFF5C4324),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),

          if (carregando)
            Container(
              color: Colors.black.withValues(alpha: 0.2),

              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFC9A227)),
              ),
            ),
        ],
      ),
    );
  }
}
