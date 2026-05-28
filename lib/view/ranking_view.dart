import 'package:flutter/material.dart';
import 'adicionar_jogadores_view.dart';

class TelaRanking extends StatelessWidget {
  const TelaRanking({super.key});

  Widget cardRanking(Map<String, dynamic> jogador, int index) {
    Color corPosicao = const Color(0xFFC9A227);

    if (index == 0) {
      corPosicao = Colors.amber;
    } else if (index == 1) {
      corPosicao = Colors.grey;
    } else if (index == 2) {
      corPosicao = const Color(0xFFCD7F32);
    }

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
          CircleAvatar(
            radius: 26,

            backgroundColor: corPosicao,

            child: Text(
              '${index + 1}',

              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  jogador['nome'],

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Telefone: ${jogador['telefone']}',

                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

            decoration: BoxDecoration(
              color: const Color(0xFFC9A227).withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Text(
              '${jogador['pontos']} pts',

              style: const TextStyle(
                color: Color(0xFF5C4324),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ranking = List.from(jogadores);

    ranking.sort((a, b) => (b['pontos'] ?? 0).compareTo(a['pontos'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),

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

              child: ranking.isEmpty
                  ? Column(
                      children: const [
                        Icon(
                          Icons.emoji_events,
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
                          Icons.emoji_events,
                          size: 70,
                          color: Color(0xFFC9A227),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Classificação',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Veja os melhores jogadores do torneio',

                          textAlign: TextAlign.center,

                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        ListView.builder(
                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: ranking.length,

                          itemBuilder: (context, index) {
                            return cardRanking(ranking[index], index);
                          },
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
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
    );
  }
}
