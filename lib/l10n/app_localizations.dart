import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'eLection'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @username.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get username;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @adminPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel de Administración'**
  String get adminPanel;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @grades.
  ///
  /// In es, this message translates to:
  /// **'Grados'**
  String get grades;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @candidates.
  ///
  /// In es, this message translates to:
  /// **'Candidatos'**
  String get candidates;

  /// No description provided for @voters.
  ///
  /// In es, this message translates to:
  /// **'Votantes'**
  String get voters;

  /// No description provided for @reports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reports;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Eliminación'**
  String get confirmDelete;

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @manageGrades.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Grados'**
  String get manageGrades;

  /// No description provided for @gradeList.
  ///
  /// In es, this message translates to:
  /// **'Listado de Grados'**
  String get gradeList;

  /// No description provided for @newGrade.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Grado'**
  String get newGrade;

  /// No description provided for @noGrades.
  ///
  /// In es, this message translates to:
  /// **'No hay grados registrados.'**
  String get noGrades;

  /// No description provided for @noGradesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron grados que coincidan.'**
  String get noGradesFound;

  /// No description provided for @manageCategories.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Categorías'**
  String get manageCategories;

  /// No description provided for @order.
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get order;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @shortName.
  ///
  /// In es, this message translates to:
  /// **'Nombre Corto'**
  String get shortName;

  /// No description provided for @actions.
  ///
  /// In es, this message translates to:
  /// **'Acciones'**
  String get actions;

  /// No description provided for @deleteGradeTitle.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR GRADO'**
  String get deleteGradeTitle;

  /// No description provided for @deleteGradeConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar el grado {name}?'**
  String deleteGradeConfirm(Object name);

  /// No description provided for @deleteGradeError.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar el grado porque tiene categorías o candidatos asociados.'**
  String get deleteGradeError;

  /// No description provided for @categoriesFor.
  ///
  /// In es, this message translates to:
  /// **'CATEGORÍAS PARA {name}'**
  String categoriesFor(Object name);

  /// No description provided for @selectAssignedCategories.
  ///
  /// In es, this message translates to:
  /// **'Seleccione las categorías asignadas:'**
  String get selectAssignedCategories;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'CERRAR'**
  String get close;

  /// No description provided for @manageCategoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Categorías'**
  String get manageCategoriesTitle;

  /// No description provided for @categoryList.
  ///
  /// In es, this message translates to:
  /// **'Listado de Categorías'**
  String get categoryList;

  /// No description provided for @newCategory.
  ///
  /// In es, this message translates to:
  /// **'Nueva Categoría'**
  String get newCategory;

  /// No description provided for @noCategories.
  ///
  /// In es, this message translates to:
  /// **'No hay categorías registradas.'**
  String get noCategories;

  /// No description provided for @noCategoriesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron categorías que coincidan.'**
  String get noCategoriesFound;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR CATEGORÍA'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar la categoría {name}?'**
  String deleteCategoryConfirm(Object name);

  /// No description provided for @deleteCategoryError.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar la categoría porque tiene grados o candidatos asociados.'**
  String get deleteCategoryError;

  /// No description provided for @gradesFor.
  ///
  /// In es, this message translates to:
  /// **'GRADOS PARA {name}'**
  String gradesFor(Object name);

  /// No description provided for @selectAssignedGrades.
  ///
  /// In es, this message translates to:
  /// **'Seleccione los grados asignados:'**
  String get selectAssignedGrades;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido al sistema de gestión electoral.'**
  String get welcomeMessage;

  /// No description provided for @students.
  ///
  /// In es, this message translates to:
  /// **'Estudiantes'**
  String get students;

  /// No description provided for @results.
  ///
  /// In es, this message translates to:
  /// **'Resultados'**
  String get results;

  /// No description provided for @ready.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get ready;

  /// No description provided for @developedBy.
  ///
  /// In es, this message translates to:
  /// **'Software desarrollado por {name}'**
  String developedBy(Object name);

  /// No description provided for @guest.
  ///
  /// In es, this message translates to:
  /// **'Invitado'**
  String get guest;

  /// No description provided for @editGrade.
  ///
  /// In es, this message translates to:
  /// **'Editar Grado'**
  String get editGrade;

  /// No description provided for @editCategory.
  ///
  /// In es, this message translates to:
  /// **'Editar Categoría'**
  String get editCategory;

  /// No description provided for @manageCandidates.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Candidatos'**
  String get manageCandidates;

  /// No description provided for @newCandidate.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Candidato'**
  String get newCandidate;

  /// No description provided for @editCandidate.
  ///
  /// In es, this message translates to:
  /// **'Editar Candidato'**
  String get editCandidate;

  /// No description provided for @deleteCandidate.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Candidato'**
  String get deleteCandidate;

  /// No description provided for @deleteCandidateConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar al candidato {name}?'**
  String deleteCandidateConfirm(Object name);

  /// No description provided for @candidateName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Candidato'**
  String get candidateName;

  /// No description provided for @candidatePicture.
  ///
  /// In es, this message translates to:
  /// **'Foto del Candidato'**
  String get candidatePicture;

  /// No description provided for @selectPicture.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Foto'**
  String get selectPicture;

  /// No description provided for @noCandidates.
  ///
  /// In es, this message translates to:
  /// **'No hay candidatos registrados en esta categoría.'**
  String get noCandidates;

  /// No description provided for @candidateSaved.
  ///
  /// In es, this message translates to:
  /// **'Candidato guardado correctamente'**
  String get candidateSaved;

  /// No description provided for @candidateDeleted.
  ///
  /// In es, this message translates to:
  /// **'Candidato eliminado correctamente'**
  String get candidateDeleted;

  /// No description provided for @manageVoters.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Votantes'**
  String get manageVoters;

  /// No description provided for @newVoter.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Votante'**
  String get newVoter;

  /// No description provided for @editVoter.
  ///
  /// In es, this message translates to:
  /// **'Editar Votante'**
  String get editVoter;

  /// No description provided for @deleteVoter.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Votante'**
  String get deleteVoter;

  /// No description provided for @deleteVoterConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar al votante {name}?'**
  String deleteVoterConfirm(Object name);

  /// No description provided for @deleteAllVoters.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Todos los Votantes'**
  String get deleteAllVoters;

  /// No description provided for @deleteAllVotersConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar TODOS los votantes? Esta acción no se puede deshacer.'**
  String get deleteAllVotersConfirm;

  /// No description provided for @importVoters.
  ///
  /// In es, this message translates to:
  /// **'Importar Votantes'**
  String get importVoters;

  /// No description provided for @noVoters.
  ///
  /// In es, this message translates to:
  /// **'No hay votantes registrados.'**
  String get noVoters;

  /// No description provided for @documentId.
  ///
  /// In es, this message translates to:
  /// **'Documento/ID'**
  String get documentId;

  /// No description provided for @voterSaved.
  ///
  /// In es, this message translates to:
  /// **'Votante guardado correctamente'**
  String get voterSaved;

  /// No description provided for @voterDeleted.
  ///
  /// In es, this message translates to:
  /// **'Votante eliminado correctamente'**
  String get voterDeleted;

  /// No description provided for @votersImported.
  ///
  /// In es, this message translates to:
  /// **'Votantes importados correctamente'**
  String get votersImported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
