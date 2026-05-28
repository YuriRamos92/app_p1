import 'package:flutter/material.dart';
import 'package:app_p1/control/control_login.dart';
import 'package:app_p1/view/ranking_view.dart';
import 'package:app_p1/main.dart';

import 'adicionar_jogadores_view.dart';
import 'jogadores_view.dart';
import 'partidas_view.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,

          backgroundColor: const Color(0xFFC9A227),
          foregroundColor: Colors.black,

          title: const Text('Pokémon TCG'),

          actions: [
            FutureBuilder<String>(
              future: LoginController().usuarioLogado(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    children: [
                      Text(
                        snapshot.data ?? '',

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          await LoginController().logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaInicial(),
                            ),
                            (route) => false,
                          );
                        },

                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),

            const SizedBox(width: 10),
          ],
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
                      Icons.catching_pokemon,
                      size: 70,
                      color: Color(0xFFC9A227),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Organizador de partidas',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Controle seus jogadores e partidas',

                      textAlign: TextAlign.center,

                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // CADASTRAR JOGADORES
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const TelaCadastroJogador(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.person_add),

                      label: const Text('Cadastrar jogadores'),

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

                    // SORTEAR PARTIDAS
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const TelaSortearPartidas(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.shuffle),

                      label: const Text('Sortear partidas'),

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

                    // VER JOGADORES
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const TelaVerJogadores(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.groups),

                      label: const Text('Ver jogadores'),

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

                    const SizedBox(height: 10),

                    // RANKING
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const TelaRanking(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.emoji_events),

                      label: const Text('Ranking'),

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

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () async {
                        await LoginController().logout();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaInicial(),
                          ),
                          (route) => false,
                        );
                      },

                      child: const Text(
                        'Sair',

                        style: TextStyle(color: Color(0xFF5C4324)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
