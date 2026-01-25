// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'eLection';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get adminPanel => 'Panel de Administración';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get settings => 'Configuración';

  @override
  String get grades => 'Grados';

  @override
  String get categories => 'Categorías';

  @override
  String get candidates => 'Candidatos';

  @override
  String get voters => 'Votantes';

  @override
  String get reports => 'Reportes';

  @override
  String get language => 'Idioma';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get manageGrades => 'Gestión de Grados';

  @override
  String get gradeList => 'Listado de Grados';

  @override
  String get newGrade => 'Nuevo Grado';

  @override
  String get noGrades => 'No hay grados registrados.';

  @override
  String get noGradesFound => 'No se encontraron grados que coincidan.';

  @override
  String get manageCategories => 'Gestionar Categorías';

  @override
  String get order => 'Orden';

  @override
  String get name => 'Nombre';

  @override
  String get shortName => 'Nombre Corto';

  @override
  String get actions => 'Acciones';

  @override
  String get deleteGradeTitle => 'ELIMINAR GRADO';

  @override
  String deleteGradeConfirm(Object name) {
    return '¿Está seguro de eliminar el grado $name?';
  }

  @override
  String get deleteGradeError =>
      'No se puede eliminar el grado porque tiene categorías o candidatos asociados.';

  @override
  String categoriesFor(Object name) {
    return 'CATEGORÍAS PARA $name';
  }

  @override
  String get selectAssignedCategories => 'Seleccione las categorías asignadas:';

  @override
  String get close => 'CERRAR';

  @override
  String get manageCategoriesTitle => 'Gestión de Categorías';

  @override
  String get categoryList => 'Listado de Categorías';

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get noCategories => 'No hay categorías registradas.';

  @override
  String get noCategoriesFound => 'No se encontraron categorías que coincidan.';

  @override
  String get deleteCategoryTitle => 'ELIMINAR CATEGORÍA';

  @override
  String deleteCategoryConfirm(Object name) {
    return '¿Está seguro de eliminar la categoría $name?';
  }

  @override
  String get deleteCategoryError =>
      'No se puede eliminar la categoría porque tiene grados o candidatos asociados.';

  @override
  String gradesFor(Object name) {
    return 'GRADOS PARA $name';
  }

  @override
  String get selectAssignedGrades => 'Seleccione los grados asignados:';

  @override
  String get search => 'Buscar';

  @override
  String get welcomeMessage => 'Bienvenido al sistema de gestión electoral.';

  @override
  String get students => 'Estudiantes';

  @override
  String get results => 'Resultados';

  @override
  String get ready => 'Listo';

  @override
  String developedBy(Object name) {
    return 'Software desarrollado por $name';
  }

  @override
  String get guest => 'Invitado';

  @override
  String get editGrade => 'Editar Grado';

  @override
  String get editCategory => 'Editar Categoría';
}
