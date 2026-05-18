import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final db = context.read<AppDatabase>();

    try {
      if (_isLogin) {
        final user = await db.login(_emailController.text, _senhaController.text);
        if (user != null) {
          // Salva a sessão para auto-login na próxima abertura
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('usuario_id', user.id);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => MainScreen(user: user)),
            );
          }
        } else {
          _showError('E-mail ou senha incorretos.');
        }
      } else {
        await db.cadastrarUsuario(UsuariosCompanion.insert(
          nome: _nomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
          dataNascimento: drift.Value(DateTime.now()), // Exemplo simplificado
        ));
        _showSuccess('Conta criada com sucesso! Faça login.');
        setState(() => _isLogin = true);
      }
    } catch (e) {
      _showError('Ocorreu um erro: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Icon(Icons.health_and_safety, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Caderneta Digital',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  _isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta agora',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 48),
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome Completo', prefixIcon: Icon(Icons.person)),
                    validator: (v) => v == null || v.isEmpty ? 'Informe seu nome' : null,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'E-mail inválido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(_isLogin ? 'ENTRAR' : 'CADASTRAR'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin 
                    ? 'Não tem uma conta? Cadastre-se' 
                    : 'Já tem uma conta? Faça login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
