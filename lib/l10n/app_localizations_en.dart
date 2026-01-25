// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'eLection';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get grades => 'Grades';

  @override
  String get categories => 'Categories';

  @override
  String get candidates => 'Candidates';

  @override
  String get voters => 'Voters';

  @override
  String get reports => 'Reports';

  @override
  String get language => 'Language';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get noData => 'No data available';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get manageGrades => 'Manage Grades';

  @override
  String get gradeList => 'Grade List';

  @override
  String get newGrade => 'New Grade';

  @override
  String get noGrades => 'No grades registered.';

  @override
  String get noGradesFound => 'No matching grades found.';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get order => 'Order';

  @override
  String get name => 'Name';

  @override
  String get shortName => 'Short Name';

  @override
  String get actions => 'Actions';

  @override
  String get deleteGradeTitle => 'DELETE GRADE';

  @override
  String deleteGradeConfirm(Object name) {
    return 'Are you sure you want to delete the grade $name?';
  }

  @override
  String get deleteGradeError =>
      'Cannot delete the grade because it has associated categories or candidates.';

  @override
  String categoriesFor(Object name) {
    return 'CATEGORIES FOR $name';
  }

  @override
  String get selectAssignedCategories => 'Select assigned categories:';

  @override
  String get close => 'CLOSE';

  @override
  String get manageCategoriesTitle => 'Manage Categories';

  @override
  String get categoryList => 'Category List';

  @override
  String get newCategory => 'New Category';

  @override
  String get noCategories => 'No categories registered.';

  @override
  String get noCategoriesFound => 'No matching categories found.';

  @override
  String get deleteCategoryTitle => 'DELETE CATEGORY';

  @override
  String deleteCategoryConfirm(Object name) {
    return 'Are you sure you want to delete the category $name?';
  }

  @override
  String get deleteCategoryError =>
      'Cannot delete the category because it has associated grades or candidates.';

  @override
  String gradesFor(Object name) {
    return 'GRADES FOR $name';
  }

  @override
  String get selectAssignedGrades => 'Select assigned grades:';

  @override
  String get search => 'Search';

  @override
  String get welcomeMessage => 'Welcome to the electoral management system.';

  @override
  String get students => 'Students';

  @override
  String get results => 'Results';

  @override
  String get ready => 'Ready';

  @override
  String developedBy(Object name) {
    return 'Software developed by $name';
  }

  @override
  String get guest => 'Guest';

  @override
  String get editGrade => 'Edit Grade';

  @override
  String get editCategory => 'Edit Category';
}
