import 'package:flutter/material.dart';

class CadastroController {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
  }

  String? validarCampos() {
    if (nomeController.text.trim().isEmpty) {
      return 'Digite o nome';
    }

    if (telefoneController.text.trim().isEmpty) {
      return 'Digite o telefone';
    }

    if (emailController.text.trim().isEmpty) {
      return 'Digite o e-mail';
    }

    if (!emailController.text.contains('@')) {
      return 'Digite um e-mail válido';
    }

    if (senhaController.text.isEmpty) {
      return 'Digite a senha';
    }

    if (senhaController.text.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }

    if (confirmarSenhaController.text.isEmpty) {
      return 'Confirme a senha';
    }

    if (senhaController.text != confirmarSenhaController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  Map<String, String> obterDados() {
    return {
      'nome': nomeController.text.trim(),
      'telefone': telefoneController.text.trim(),
      'email': emailController.text.trim(),
      'senha': senhaController.text,
    };
  }

  void limparCampos() {
    nomeController.clear();
    telefoneController.clear();
    emailController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
  }
}
