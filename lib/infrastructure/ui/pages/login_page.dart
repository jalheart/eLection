import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/auth_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _errorMessage;

  Future<void> _checkUsername() async {
    final authProvider = context.read<AuthProvider>();
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese un usuario');
      return;
    }

    final user = await authProvider.checkUsername(username);

    if (user != null) {
      setState(() {
        _showPassword = true;
        _errorMessage = null;
      });
    } else {
      setState(() => _errorMessage = 'Usuario no encontrado');
    }
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();
    final password = _passwordController.text;

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese la contraseña');
      return;
    }

    final success = await authProvider.login(
      _usernameController.text.trim(),
      password,
    );

    if (!success) {
      setState(() => _errorMessage = 'Contraseña incorrecta');
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
                  labelText: AppLocalizations.of(context)!.username,
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
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
                child: Text(
                  _showPassword
                      ? AppLocalizations.of(context)!.login
                      : 'Siguiente',
                ),
              ),
              if (_showPassword)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = false;
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
