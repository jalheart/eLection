import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcrypt/bcrypt.dart';
import 'database.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  User? _foundUser;
  String? _errorMessage;

  Future<void> _checkUsername() async {
    final database = context.read<AppDatabase>();
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese un usuario');
      return;
    }

    final user = await (database.select(
      database.users,
    )..where((u) => u.username.equals(username))).getSingleOrNull();

    if (user != null) {
      setState(() {
        _foundUser = user;
        _showPassword = true;
        _errorMessage = null;
      });
    } else {
      setState(() => _errorMessage = 'Usuario no encontrado');
    }
  }

  Future<void> _login() async {
    final password = _passwordController.text;

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese la contraseña');
      return;
    }

    if (_foundUser != null) {
      final isValid = BCrypt.checkpw(password, _foundUser!.password);
      if (isValid) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        setState(() => _errorMessage = 'Contraseña incorrecta');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'eLection Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  errorText: _errorMessage,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                enabled: !_showPassword,
                onSubmitted: (_) => _checkUsername(),
              ),
              if (_showPassword) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  autofocus: true,
                  onSubmitted: (_) => _login(),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _showPassword ? _login : _checkUsername,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(_showPassword ? 'Ingresar' : 'Siguiente'),
              ),
              if (_showPassword)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = false;
                      _foundUser = null;
                      _passwordController.clear();
                    });
                  },
                  child: const Text('Cambiar usuario'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
