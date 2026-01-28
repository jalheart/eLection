import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/auth_provider.dart';
import '../../../application/providers/settings_provider.dart';
import '../../../application/use_cases/identify_user_use_case.dart';
import 'package:myapp/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _errorMessage;
  UserType? _identifiedType;
  bool _isLoading = false;

  Future<void> _identify() async {
    final authProvider = context.read<AuthProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final identifier = _identifierController.text.trim();

    if (identifier.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese su documento o usuario');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await authProvider.identifyUser(identifier);

      if (result != null) {
        _identifiedType = result.type;
        
        if (result.type == UserType.voter) {
          final passRequired = settingsProvider.settings?.passRequired ?? false;
          if (!passRequired) {
            // Log in immediately
            final success = await authProvider.loginVoter(identifier, null, passRequired: false);
            if (success) {
              // Navigation is handled by main.dart listening to AuthProvider
              return;
            } else {
              setState(() => _errorMessage = 'Error al iniciar sesión');
            }
          } else {
            // Show password field for voter
            setState(() {
              _showPassword = true;
            });
          }
        } else {
          // Admin, always show password
          setState(() {
            _showPassword = true;
          });
        }
      } else {
        setState(() => _errorMessage = 'Usuario o documento no encontrado');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();
    final password = _passwordController.text;
    final identifier = _identifierController.text.trim();

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingrese la contraseña');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = false;
      if (_identifiedType == UserType.admin) {
        success = await authProvider.loginAdmin(identifier, password);
      } else if (_identifiedType == UserType.voter) {
        success = await authProvider.loginVoter(identifier, password, passRequired: true);
      }

      if (!success) {
        setState(() => _errorMessage = 'Contraseña incorrecta');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.how_to_vote, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      l10n.appName,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _identifierController,
                      decoration: InputDecoration(
                        labelText: 'Documento o Usuario',
                        errorText: _errorMessage,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      enabled: !_showPassword && !_isLoading,
                      onSubmitted: (_) => _identify(),
                    ),
                    if (_showPassword) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        autofocus: true,
                        enabled: !_isLoading,
                        onSubmitted: (_) => _login(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : (_showPassword ? _login : _identify),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                _showPassword ? l10n.login : 'Siguiente',
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    if (_showPassword && !_isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = false;
                            _passwordController.clear();
                            _identifiedType = null;
                          });
                        },
                        child: const Text('Cambiar usuario'),
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
