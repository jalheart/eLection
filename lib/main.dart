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
import 'application/use_cases/get_candidates_use_case.dart';
import 'application/use_cases/get_candidates_by_category_use_case.dart';
import 'application/use_cases/save_candidate_use_case.dart';
import 'application/use_cases/delete_candidate_use_case.dart';
import 'application/providers/candidates_provider.dart';
import 'application/providers/grade_category_provider.dart';
import 'application/providers/voting_provider.dart';
import 'application/providers/voters_provider.dart';
import 'application/use_cases/get_voters_use_case.dart';
import 'application/use_cases/get_voters_by_grade_use_case.dart';
import 'application/use_cases/save_voter_use_case.dart';
import 'application/use_cases/delete_voter_use_case.dart';
import 'application/use_cases/save_voters_use_case.dart';
import 'application/use_cases/delete_all_voters_use_case.dart';
import 'infrastructure/database/adapters/drift_candidate_repository.dart';
import 'infrastructure/database/adapters/drift_voter_repository.dart';
import 'infrastructure/database/adapters/drift_vote_repository.dart';
import 'application/use_cases/get_voter_by_document_id_use_case.dart';
import 'application/use_cases/cast_votes_use_case.dart';
import 'infrastructure/database/database.dart';
import 'infrastructure/ui/pages/login_page.dart';
import 'infrastructure/ui/pages/admin_landing_page.dart';
import 'infrastructure/ui/pages/voter_landing_page.dart';
import 'application/use_cases/login_voter_use_case.dart';
import 'application/use_cases/identify_user_use_case.dart';
import 'application/use_cases/update_settings_use_case.dart';
import 'application/use_cases/get_results_use_case.dart';
import 'application/providers/results_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/l10n/app_localizations.dart';

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
        ProxyProvider<AppDatabase, DriftCandidateRepository>(
          update: (context, db, _) => DriftCandidateRepository(db),
        ),
        ProxyProvider<AppDatabase, DriftVoterRepository>(
          update: (context, db, _) => DriftVoterRepository(db),
        ),
        ProxyProvider<AppDatabase, DriftVoteRepository>(
          update: (context, db, _) => DriftVoteRepository(db),
        ),
        // Use Cases
        // Use Cases
        ProxyProvider<DriftUserRepository, LoginUseCase>(
          update: (context, repo, _) => LoginUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, LoginVoterUseCase>(
          update: (context, repo, _) => LoginVoterUseCase(repo),
        ),
        ProxyProvider2<DriftUserRepository, DriftVoterRepository, IdentifyUserUseCase>(
          update: (context, userRepo, voterRepo, _) => IdentifyUserUseCase(userRepo, voterRepo),
        ),
        ProxyProvider<DriftUserRepository, CheckUsernameUseCase>(
          update: (context, repo, _) => CheckUsernameUseCase(repo),
        ),
        ProxyProvider<DriftSettingsRepository, GetSettingsUseCase>(
          update: (context, repo, _) => GetSettingsUseCase(repo),
        ),
        ProxyProvider<DriftSettingsRepository, UpdateSettingsUseCase>(
          update: (context, repo, _) => UpdateSettingsUseCase(repo),
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
        ProxyProvider<DriftCandidateRepository, GetCandidatesUseCase>(
          update: (context, repo, _) => GetCandidatesUseCase(repo),
        ),
        ProxyProvider<DriftCandidateRepository, GetCandidatesByCategoryUseCase>(
          update: (context, repo, _) => GetCandidatesByCategoryUseCase(repo),
        ),
        ProxyProvider<DriftCandidateRepository, SaveCandidateUseCase>(
          update: (context, repo, _) => SaveCandidateUseCase(repo),
        ),
        ProxyProvider<DriftCandidateRepository, DeleteCandidateUseCase>(
          update: (context, repo, _) => DeleteCandidateUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, GetVotersUseCase>(
          update: (context, repo, _) => GetVotersUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, GetVotersByGradeUseCase>(
          update: (context, repo, _) => GetVotersByGradeUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, SaveVoterUseCase>(
          update: (context, repo, _) => SaveVoterUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, DeleteVoterUseCase>(
          update: (context, repo, _) => DeleteVoterUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, SaveVotersUseCase>(
          update: (context, repo, _) => SaveVotersUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, DeleteAllVotersUseCase>(
          update: (context, repo, _) => DeleteAllVotersUseCase(repo),
        ),
        ProxyProvider<DriftVoterRepository, GetVoterByDocumentIdUseCase>(
          update: (context, repo, _) => GetVoterByDocumentIdUseCase(repo),
        ),
        ProxyProvider2<DriftVoteRepository, DriftVoterRepository, CastVotesUseCase>(
          update: (context, voteRepo, voterRepo, _) => CastVotesUseCase(voteRepo, voterRepo),
        ),
        ProxyProvider<DriftVoteRepository, GetResultsUseCase>(
          update: (context, repo, _) => GetResultsUseCase(repo),
        ),

        // Providers
        ChangeNotifierProxyProvider3<
          LoginUseCase,
          LoginVoterUseCase,
          IdentifyUserUseCase,
          AuthProvider
        >(
          create: (context) => AuthProvider(
            loginUseCase: context.read<LoginUseCase>(),
            loginVoterUseCase: context.read<LoginVoterUseCase>(),
            identifyUserUseCase: context.read<IdentifyUserUseCase>(),
          ),
          update: (context, loginUC, loginVoterUC, identifyUC, previous) =>
              previous ?? AuthProvider(
                loginUseCase: loginUC,
                loginVoterUseCase: loginVoterUC,
                identifyUserUseCase: identifyUC,
              ),
        ),
        ChangeNotifierProxyProvider2<
          GetSettingsUseCase,
          UpdateSettingsUseCase,
          SettingsProvider
        >(
          create: (context) => SettingsProvider(
            context.read<GetSettingsUseCase>(),
            context.read<UpdateSettingsUseCase>(),
          ),
          update: (context, getUC, updateUC, previous) =>
              previous ?? SettingsProvider(getUC, updateUC),
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
        ChangeNotifierProxyProvider4<
          GetCandidatesUseCase,
          GetCandidatesByCategoryUseCase,
          SaveCandidateUseCase,
          DeleteCandidateUseCase,
          CandidatesProvider
        >(
          create: (context) => CandidatesProvider(
            context.read<GetCandidatesUseCase>(),
            context.read<GetCandidatesByCategoryUseCase>(),
            context.read<SaveCandidateUseCase>(),
            context.read<DeleteCandidateUseCase>(),
          ),
          update: (context, getUC, getByCatUC, saveUC, deleteUC, previous) =>
              previous ??
              CandidatesProvider(getUC, getByCatUC, saveUC, deleteUC),
        ),
        ChangeNotifierProxyProvider3<
          GetCategoriesByGradeUseCase,
          GetCandidatesByCategoryUseCase,
          CastVotesUseCase,
          VotingProvider
        >(
          create: (context) => VotingProvider(
            context.read<GetCategoriesByGradeUseCase>(),
            context.read<GetCandidatesByCategoryUseCase>(),
            context.read<CastVotesUseCase>(),
          ),
          update: (context, catUC, candUC, castUC, previous) =>
              previous ?? VotingProvider(catUC, candUC, castUC),
        ),
        ChangeNotifierProvider<VotersProvider>(
          create: (context) => VotersProvider(
            context.read<GetVotersUseCase>(),
            context.read<GetVotersByGradeUseCase>(),
            context.read<SaveVoterUseCase>(),
            context.read<DeleteVoterUseCase>(),
            context.read<SaveVotersUseCase>(),
            context.read<DeleteAllVotersUseCase>(),
            context.read<GetVoterByDocumentIdUseCase>(),
          ),
        ),
        ChangeNotifierProxyProvider3<
          GetCategoriesUseCase,
          GetCandidatesByCategoryUseCase,
          GetResultsUseCase,
          ResultsProvider
        >(
          create: (context) => ResultsProvider(
            context.read<GetCategoriesUseCase>(),
            context.read<GetCandidatesByCategoryUseCase>(),
            context.read<GetResultsUseCase>(),
          ),
          update: (context, getCatUC, getCandUC, getResUC, previous) =>
              previous ?? ResultsProvider(getCatUC, getCandUC, getResUC),
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
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
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
          locale: settingsProvider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
            Locale('fr'),
            Locale('pt'),
          ],
          home: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isAuthenticated) {
                if (auth.isAdmin) {
                  return const AdminLandingPage();
                } else if (auth.isVoter) {
                  return const VoterLandingPage();
                }
              }
              return const LoginPage();
            },
          ),
        );
      },
    );
  }
}
