import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  String? idUsuario() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String> usuarioLogado() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return '';
    }

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return (doc.data()?['nome'] ?? '').toString().trim();
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
