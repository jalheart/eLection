// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'eLection';

  @override
  String get login => 'Connexion';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get adminPanel => 'Panneau d\'administration';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'Paramètres';

  @override
  String get grades => 'Grades';

  @override
  String get categories => 'Catégories';

  @override
  String get candidates => 'Candidats';

  @override
  String get voters => 'Électeurs';

  @override
  String get reports => 'Rapports';

  @override
  String get language => 'Langue';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get manageGrades => 'Gestion des Grades';

  @override
  String get gradeList => 'Liste des Grades';

  @override
  String get newGrade => 'Nouveau Grade';

  @override
  String get noGrades => 'Aucun grade enregistré.';

  @override
  String get noGradesFound => 'Aucun grade correspondant trouvé.';

  @override
  String get manageCategories => 'Gérer les Catégories';

  @override
  String get order => 'Ordre';

  @override
  String get name => 'Nom';

  @override
  String get shortName => 'Nom Court';

  @override
  String get actions => 'Actions';

  @override
  String get deleteGradeTitle => 'SUPPRIMER LE GRADE';

  @override
  String deleteGradeConfirm(Object name) {
    return 'Êtes-vous sûr de vouloir supprimer le grade $name ?';
  }

  @override
  String get deleteGradeError =>
      'Impossible de supprimer le grade car il a des catégories ou des candidats associés.';

  @override
  String categoriesFor(Object name) {
    return 'CATÉGORIES POUR $name';
  }

  @override
  String get selectAssignedCategories =>
      'Sélectionnez les catégories assignées :';

  @override
  String get close => 'FERMER';

  @override
  String get manageCategoriesTitle => 'Gestion des Catégories';

  @override
  String get categoryList => 'Liste des Catégories';

  @override
  String get newCategory => 'Nouvelle Catégorie';

  @override
  String get noCategories => 'Aucune catégorie enregistrée.';

  @override
  String get noCategoriesFound => 'Aucune catégorie correspondante trouvée.';

  @override
  String get deleteCategoryTitle => 'SUPPRIMER LA CATÉGORIE';

  @override
  String deleteCategoryConfirm(Object name) {
    return 'Êtes-vous sûr de vouloir supprimer la catégorie $name ?';
  }

  @override
  String get deleteCategoryError =>
      'Impossible de supprimer la catégorie car elle a des grades ou des candidats associés.';

  @override
  String gradesFor(Object name) {
    return 'GRADES POUR $name';
  }

  @override
  String get selectAssignedGrades => 'Sélectionnez les grades assignés :';

  @override
  String get search => 'Rechercher';

  @override
  String get welcomeMessage =>
      'Bienvenue dans le système de gestion électorale.';

  @override
  String get students => 'Étudiants';

  @override
  String get results => 'Résultats';

  @override
  String get ready => 'Prêt';

  @override
  String developedBy(Object name) {
    return 'Logiciel développé par $name';
  }

  @override
  String get guest => 'Invité';

  @override
  String get editGrade => 'Modifier le Grade';

  @override
  String get editCategory => 'Modifier la Catégorie';

  @override
  String get manageCandidates => 'Gestionar Candidatos';

  @override
  String get newCandidate => 'Nuevo Candidato';

  @override
  String get editCandidate => 'Editar Candidato';

  @override
  String get deleteCandidate => 'Eliminar Candidato';

  @override
  String deleteCandidateConfirm(Object name) {
    return '¿Está seguro de eliminar al candidato $name?';
  }

  @override
  String get candidateName => 'Nombre del Candidato';

  @override
  String get candidatePicture => 'Foto del Candidato';

  @override
  String get selectPicture => 'Seleccionar Foto';

  @override
  String get noCandidates => 'No hay candidatos registrados en esta categoría.';

  @override
  String get candidateSaved => 'Candidato guardado correctamente';

  @override
  String get candidateDeleted => 'Candidato eliminado correctamente';
}
