import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/providers/auth_provider.dart';
import 'application/providers/settings_provider.dart';
import 'application/use_cases/check_username_use_case.dart';
import 'application/use_cases/login_use_case.dart';
import 'application/use_cases/get_settings_use_case.dart';
import 'application/use_cases/get_grados_use_case.dart';
import 'application/use_cases/save_grado_use_case.dart';
import 'application/use_cases/delete_grado_use_case.dart';
import 'application/providers/grados_provider.dart';
import 'application/providers/categories_provider.dart';
import 'application/use_cases/get_categories_use_case.dart';
import 'application/use_cases/save_category_use_case.dart';
import 'application/use_cases/delete_category_use_case.dart';
import 'infrastructure/database/adapters/drift_user_repository.dart';
import 'infrastructure/database/adapters/drift_settings_repository.dart';
import 'infrastructure/database/adapters/drift_grado_repository.dart';
import 'infrastructure/database/adapters/drift_category_repository.dart';
import 'infrastructure/database/adapters/drift_grade_category_repository.dart';
import 'application/use_cases/get_categories_by_grade_use_case.dart';
import 'application/use_cases/get_grades_by_category_use_case.dart';
import 'application/use_cases/assign_category_to_grade_use_case.dart';
import 'application/use_cases/unassign_category_from_grade_use_case.dart';
import 'application/use_cases/get_all_assignments_use_case.dart';
import 'application/providers/grade_category_provider.dart';
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
        ProxyProvider<AppDatabase, DriftGradoRepository>(
          update: (context, db, _) => DriftGradoRepository(db),
        ),
        ProxyProvider<AppDatabase, DriftCategoryRepository>(
          update: (context, db, _) => DriftCategoryRepository(db),
        ),
        ProxyProvider<AppDatabase, DriftGradeCategoryRepository>(
          update: (context, db, _) => DriftGradeCategoryRepository(db),
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
        ProxyProvider<DriftGradoRepository, GetGradosUseCase>(
          update: (context, repo, _) => GetGradosUseCase(repo),
        ),
        ProxyProvider<DriftGradoRepository, SaveGradoUseCase>(
          update: (context, repo, _) => SaveGradoUseCase(repo),
        ),
        ProxyProvider<DriftGradoRepository, DeleteGradoUseCase>(
          update: (context, repo, _) => DeleteGradoUseCase(repo),
        ),
        ProxyProvider<DriftCategoryRepository, GetCategoriesUseCase>(
          update: (context, repo, _) => GetCategoriesUseCase(repo),
        ),
        ProxyProvider<DriftCategoryRepository, SaveCategoryUseCase>(
          update: (context, repo, _) => SaveCategoryUseCase(repo),
        ),
        ProxyProvider<DriftCategoryRepository, DeleteCategoryUseCase>(
          update: (context, repo, _) => DeleteCategoryUseCase(repo),
        ),
        ProxyProvider<
          DriftGradeCategoryRepository,
          GetCategoriesByGradeUseCase
        >(update: (context, repo, _) => GetCategoriesByGradeUseCase(repo)),
        ProxyProvider<DriftGradeCategoryRepository, GetGradesByCategoryUseCase>(
          update: (context, repo, _) => GetGradesByCategoryUseCase(repo),
        ),
        ProxyProvider<
          DriftGradeCategoryRepository,
          AssignCategoryToGradeUseCase
        >(update: (context, repo, _) => AssignCategoryToGradeUseCase(repo)),
        ProxyProvider<
          DriftGradeCategoryRepository,
          UnassignCategoryFromGradeUseCase
        >(update: (context, repo, _) => UnassignCategoryFromGradeUseCase(repo)),
        ProxyProvider<DriftGradeCategoryRepository, GetAllAssignmentsUseCase>(
          update: (context, repo, _) => GetAllAssignmentsUseCase(repo),
        ),
        // Providers
        ChangeNotifierProxyProvider2<
          LoginUseCase,
          CheckUsernameUseCase,
          AuthProvider
        >(
          create: (context) => AuthProvider(
            context.read<LoginUseCase>(),
            context.read<CheckUsernameUseCase>(),
          ),
          update: (context, loginUC, checkUC, previous) =>
              previous ?? AuthProvider(loginUC, checkUC),
        ),
        ChangeNotifierProxyProvider<GetSettingsUseCase, SettingsProvider>(
          create: (context) =>
              SettingsProvider(context.read<GetSettingsUseCase>()),
          update: (context, getSettingsUC, previous) =>
              previous ?? SettingsProvider(getSettingsUC),
        ),
        ChangeNotifierProxyProvider3<
          GetGradosUseCase,
          SaveGradoUseCase,
          DeleteGradoUseCase,
          GradosProvider
        >(
          create: (context) => GradosProvider(
            context.read<GetGradosUseCase>(),
            context.read<SaveGradoUseCase>(),
            context.read<DeleteGradoUseCase>(),
          ),
          update: (context, getUC, saveUC, deleteUC, previous) =>
              previous ?? GradosProvider(getUC, saveUC, deleteUC),
        ),
        ChangeNotifierProxyProvider3<
          GetCategoriesUseCase,
          SaveCategoryUseCase,
          DeleteCategoryUseCase,
          CategoriesProvider
        >(
          create: (context) => CategoriesProvider(
            context.read<GetCategoriesUseCase>(),
            context.read<SaveCategoryUseCase>(),
            context.read<DeleteCategoryUseCase>(),
          ),
          update: (context, getUC, saveUC, deleteUC, previous) =>
              previous ?? CategoriesProvider(getUC, saveUC, deleteUC),
        ),
        ChangeNotifierProxyProvider5<
          GetCategoriesByGradeUseCase,
          GetGradesByCategoryUseCase,
          AssignCategoryToGradeUseCase,
          UnassignCategoryFromGradeUseCase,
          GetAllAssignmentsUseCase,
          GradeCategoryProvider
        >(
          create: (context) => GradeCategoryProvider(
            context.read<GetCategoriesByGradeUseCase>(),
            context.read<GetGradesByCategoryUseCase>(),
            context.read<AssignCategoryToGradeUseCase>(),
            context.read<UnassignCategoryFromGradeUseCase>(),
            context.read<GetAllAssignmentsUseCase>(),
          ),
          update:
              (
                context,
                getCatUC,
                getGradoUC,
                assignUC,
                unassignUC,
                getAllUC,
                previous,
              ) =>
                  previous ??
                  GradeCategoryProvider(
                    getCatUC,
                    getGradoUC,
                    assignUC,
                    unassignUC,
                    getAllUC,
                  ),
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

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final settings = settingsProvider.settings;
        Color seedColor = Colors.blue;

        if (settings != null && settings.theme.isNotEmpty) {
          try {
            seedColor = Color(int.parse(settings.theme));
          } catch (_) {
            seedColor = Colors.blue;
          }
        }

        return MaterialApp(
          title: 'eLection',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
            ).copyWith(primary: seedColor),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: seedColor,
              foregroundColor: Colors.white,
            ),
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
      },
    );
  }
}
