import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
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
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFFF8F4E8),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Column(
                      children: [
                        Icon(Icons.person, size: 40, color: Color(0xFFC9A227)),

                        SizedBox(height: 10),

                        Text(
                          'App desenvolvido por:',

                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Yuri Ramos da Silva',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // MATÉRIA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Column(
                      children: [
                        Icon(Icons.school, size: 40, color: Color(0xFFC9A227)),

                        SizedBox(height: 10),

                        Text(
                          'Matéria:',

                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Programação para dispositivos móveis',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // RA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Column(
                      children: [
                        Icon(Icons.badge, size: 40, color: Color(0xFFC9A227)),

                        SizedBox(height: 10),

                        Text(
                          'RA:',

                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        SizedBox(height: 6),

                        Text(
                          '2840482511037',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton.icon(
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
