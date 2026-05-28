import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'view/home_view.dart';
import 'view/sobre_view.dart';
import 'view/tela_cadastro_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppPokemon());
}

class AppPokemon extends StatelessWidget {
  const AppPokemon({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Pokemon',
      home: const VerificarLoginInicial(),
    );
  }
}

class VerificarLoginInicial extends StatelessWidget {
  const VerificarLoginInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const TelaHome();
        }

        return const TelaInicial();
      },
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> fazerLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      erro('Preencha e-mail e senha');
      return;
    }

    if (!email.contains('@')) {
      erro('Digite um e-mail válido');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaHome()),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao fazer login';

      if (e.code == 'user-not-found') {
        mensagem = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        mensagem = 'E-mail inválido';
      } else if (e.code == 'invalid-credential') {
        mensagem = 'E-mail ou senha incorretos';
      }

      erro(mensagem);
    }
  }

  void recuperarSenha() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController recuperarController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Recuperar senha'),
          content: TextField(
            controller: recuperarController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Digite seu e-mail',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
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
                esqueceuSenha(context, recuperarController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9A227),
                foregroundColor: Colors.black,
              ),
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> esqueceuSenha(BuildContext context, String email) async {
    if (email.isEmpty) {
      erro('Informe o e-mail para recuperar a senha.');
      return;
    }

    if (!email.contains('@')) {
      erro('Digite um e-mail válido.');
      return;
    }

    Navigator.pop(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      sucesso('E-mail enviado com sucesso.');
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao recuperar senha';

      if (e.code == 'user-not-found') {
        mensagem = 'Nenhum usuário encontrado com esse e-mail';
      } else if (e.code == 'invalid-email') {
        mensagem = 'E-mail inválido';
      }

      erro(mensagem);
    }
  }

  void erro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  void sucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    Icons.account_circle,
                    size: 80,
                    color: Color(0xFFC9A227),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Bem-vindo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entre com seu e-mail e senha',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: recuperarSenha,
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: Color(0xFF5C4324),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: fazerLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A227),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ainda não tem conta? ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaCadastro(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFF5C4324),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaSobre(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sobre',
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
