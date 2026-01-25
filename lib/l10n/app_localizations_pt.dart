// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'eLection';

  @override
  String get login => 'Entrar';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get adminPanel => 'Painel de Administração';

  @override
  String get logout => 'Sair';

  @override
  String get settings => 'Configurações';

  @override
  String get grades => 'Séries';

  @override
  String get categories => 'Categorias';

  @override
  String get candidates => 'Candidatos';

  @override
  String get voters => 'Eleitores';

  @override
  String get reports => 'Relatórios';

  @override
  String get language => 'Idioma';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirmDelete => 'Confirmar Exclusão';

  @override
  String get noData => 'Nenhum dado disponível';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get manageGrades => 'Gestão de Séries';

  @override
  String get gradeList => 'Lista de Séries';

  @override
  String get newGrade => 'Nova Série';

  @override
  String get noGrades => 'Nenhuma série registrada.';

  @override
  String get noGradesFound => 'Nenhuma série correspondente encontrada.';

  @override
  String get manageCategories => 'Gerenciar Categorias';

  @override
  String get order => 'Ordem';

  @override
  String get name => 'Nome';

  @override
  String get shortName => 'Nome Curto';

  @override
  String get actions => 'Ações';

  @override
  String get deleteGradeTitle => 'EXCLUIR SÉRIE';

  @override
  String deleteGradeConfirm(Object name) {
    return 'Tem certeza de que deseja excluir a série $name?';
  }

  @override
  String get deleteGradeError =>
      'Não é possível excluir a série porque ela possui categorias ou candidatos associados.';

  @override
  String categoriesFor(Object name) {
    return 'CATEGORIAS PARA $name';
  }

  @override
  String get selectAssignedCategories => 'Selecione as categorias atribuídas:';

  @override
  String get close => 'FECHAR';

  @override
  String get manageCategoriesTitle => 'Gestão de Categorias';

  @override
  String get categoryList => 'Lista de Categorias';

  @override
  String get newCategory => 'Nova Categoria';

  @override
  String get noCategories => 'Nenhuma categoria registrada.';

  @override
  String get noCategoriesFound =>
      'Nenhuma categoria correspondente encontrada.';

  @override
  String get deleteCategoryTitle => 'EXCLUIR CATEGORIA';

  @override
  String deleteCategoryConfirm(Object name) {
    return 'Tem certeza de que deseja excluir a categoria $name?';
  }

  @override
  String get deleteCategoryError =>
      'Não é possível excluir a categoria porque ela possui séries ou candidatos associados.';

  @override
  String gradesFor(Object name) {
    return 'SÉRIES PARA $name';
  }

  @override
  String get selectAssignedGrades => 'Selecione as séries atribuídas:';

  @override
  String get search => 'Buscar';

  @override
  String get welcomeMessage => 'Bem-vindo ao sistema de gestão eleitoral.';

  @override
  String get students => 'Estudantes';

  @override
  String get results => 'Resultados';

  @override
  String get ready => 'Pronto';

  @override
  String developedBy(Object name) {
    return 'Software desenvolvido por $name';
  }

  @override
  String get guest => 'Convidado';

  @override
  String get editGrade => 'Editar Série';

  @override
  String get editCategory => 'Editar Categoria';
}
