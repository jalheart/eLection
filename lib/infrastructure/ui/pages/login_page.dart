import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
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
        success = await authProvider.loginVoter(identifier, password,
            passRequired: true);
      }

      if (!success) {
        setState(() => _errorMessage = 'Contraseña incorrecta');
      } else {
        // If login successful, main.dart's Consumer<AuthProvider> will handle navigation.
        // We don't need to do anything here.
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final settings = settingsProvider.settings;
          final theme = Theme.of(context);

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Institutional Header
                    if (settings?.logo != null && settings!.logo.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        height: 120,
                        child: Builder(
                          builder: (context) {
                            final logo = settings.logo;
                            if (logo.startsWith('assets/')) {
                              return Image.asset(logo, fit: BoxFit.contain);
                            } else if (p.isAbsolute(logo)) {
                              return Image.file(File(logo), fit: BoxFit.contain);
                            } else {
                              final resolved = settingsProvider.resolvePath(logo);
                              return resolved != null
                                  ? Image.file(File(resolved), fit: BoxFit.contain)
                                  : Icon(Icons.school, size: 80, color: theme.primaryColor);
                            }
                          },
                        ),
                      )
                    else 
                      Icon(Icons.school, size: 80, color: theme.primaryColor.withOpacity(0.5)),
                    
                    Text(
                      settings?.name ?? 'eLection',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (settings?.slogan != null && settings!.slogan.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        settings.slogan,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 48),
                    
                    // Login Card
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              l10n.login,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _identifierController,
                              decoration: InputDecoration(
                                labelText: l10n.username,
                                errorText: _errorMessage,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              enabled: !_showPassword && !_isLoading,
                              onSubmitted: (_) => _identify(),
                            ),
                            if (_showPassword) ...[
                              const SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                                obscureText: true,
                                autofocus: true,
                                enabled: !_isLoading,
                                onSubmitted: (_) => _login(),
                              ),
                            ],
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _isLoading ? null : (_showPassword ? _login : _identify),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _showPassword ? l10n.login : 'SIGUIENTE',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                            if (_showPassword && !_isLoading) ...[
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = false;
                                    _passwordController.clear();
                                    _identifiedType = null;
                                  });
                                },
                                child: Text(
                                  'Cambiar usuario',
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'eLection',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'v1.0.0',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.developedBy('Jaime Hernández'),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
