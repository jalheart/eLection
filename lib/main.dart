import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/providers/auth_provider.dart';
import 'application/providers/settings_provider.dart';
import 'application/use_cases/check_username_use_case.dart';
import 'application/use_cases/login_use_case.dart';
import 'application/use_cases/get_settings_use_case.dart';
import 'infrastructure/database/adapters/drift_user_repository.dart';
import 'infrastructure/database/adapters/drift_settings_repository.dart';
import 'infrastructure/database/database.dart';
import 'infrastructure/ui/pages/login_page.dart';
import 'infrastructure/ui/pages/admin_landing_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (context) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        // Repositories
        ProxyProvider<AppDatabase, DriftUserRepository>(
          update: (context, db, _) => DriftUserRepository(db),
        ),
        ProxyProvider<AppDatabase, DriftSettingsRepository>(
          update: (context, db, _) => DriftSettingsRepository(db),
        ),
        // Use Cases
        ProxyProvider<DriftUserRepository, LoginUseCase>(
          update: (context, repo, _) => LoginUseCase(repo),
        ),
        ProxyProvider<DriftUserRepository, CheckUsernameUseCase>(
          update: (context, repo, _) => CheckUsernameUseCase(repo),
        ),
        ProxyProvider<DriftSettingsRepository, GetSettingsUseCase>(
          update: (context, repo, _) => GetSettingsUseCase(repo),
        ),
        // Providers
        ChangeNotifierProxyProvider2<LoginUseCase, CheckUsernameUseCase, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<LoginUseCase>(),
            context.read<CheckUsernameUseCase>(),
          ),
          update: (context, loginUC, checkUC, previous) =>
              previous ?? AuthProvider(loginUC, checkUC),
        ),
        ChangeNotifierProxyProvider<GetSettingsUseCase, SettingsProvider>(
          create: (context) => SettingsProvider(context.read<GetSettingsUseCase>()),
          update: (context, getSettingsUC, previous) =>
              previous ?? SettingsProvider(getSettingsUC),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Load settings once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadSettings();
    });

    return MaterialApp(
      title: 'eLection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const AdminLandingPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
