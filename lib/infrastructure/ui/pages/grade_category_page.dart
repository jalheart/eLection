import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/grade_category_provider.dart';
import '../../../application/providers/grados_provider.dart';
import '../../../application/providers/categories_provider.dart';
import '../../../domain/entities/grado.dart';
import '../../../domain/entities/category.dart';
import '../widgets/admin_layout.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/custom_search_bar.dart';

class GradeCategoryPage extends StatefulWidget {
  const GradeCategoryPage({super.key});

  @override
  State<GradeCategoryPage> createState() => _GradeCategoryPageState();
}

class _GradeCategoryPageState extends State<GradeCategoryPage> {
  int? _sortColumnIndex;
  bool _isAscending = true;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final TextEditingController _filterController = TextEditingController();
  String _filterText = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GradeCategoryProvider>().loadAssignments();
      context.read<GradosProvider>().loadGrados();
      context.read<CategoriesProvider>().loadCategories();
    });
  }

  void _showAssignmentForm([Map<String, dynamic>? assignment]) {
    showDialog(
      context: context,
      builder: (context) => _AssignmentFormDialog(assignment: assignment),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Categorías por Grado',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Listado de Asignaciones',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAssignmentForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Asignación'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomSearchBar(
              controller: _filterController,
              onChanged: (value) {
                setState(() {
                  _filterText = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<GradeCategoryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.assignments.isEmpty) {
                    return const Center(
                      child: Text('No hay asignaciones registradas.'),
                    );
                  }

                  List<Map<String, dynamic>> filtered = provider.assignments
                      .where((a) {
                        final grade = a['grade'] as Grado;
                        final category = a['category'] as Category;
                        return grade.name.toLowerCase().contains(_filterText) ||
                            category.name.toLowerCase().contains(_filterText);
                      })
                      .toList();

                  if (_sortColumnIndex != null) {
                    filtered.sort((a, b) {
                      int compareResult = 0;
                      final gradeA = a['grade'] as Grado;
                      final gradeB = b['grade'] as Grado;
                      final catA = a['category'] as Category;
                      final catB = b['category'] as Category;

                      switch (_sortColumnIndex) {
                        case 0:
                          compareResult = gradeA.name.compareTo(gradeB.name);
                          break;
                        case 1:
                          compareResult = catA.name.compareTo(catB.name);
                          break;
                      }
                      return _isAscending ? compareResult : -compareResult;
                    });
                  }

                  final dataSource = _AssignmentDataSource(
                    assignments: filtered,
                    onEdit: _showAssignmentForm,
                    onDelete: (assignment) {
                      final grade = assignment['grade'] as Grado;
                      final category = assignment['category'] as Category;
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: 'ELIMINAR ASIGNACIÓN',
                          content:
                              '¿Está seguro de eliminar la categoría ${category.name} del grado ${grade.name}?',
                          onConfirm: () {
                            provider.unassign(grade.id!, category.id!);
                          },
                        ),
                      );
                    },
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: PaginatedDataTable2(
                      wrapInCard: false,
                      showCheckboxColumn: false,
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                      minWidth: 600,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _isAscending,
                      columns: [
                        DataColumn2(
                          label: const Text(
                            'Grado',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _isAscending = ascending;
                            });
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            'Categoría',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _isAscending = ascending;
                            });
                          },
                        ),
                        const DataColumn2(
                          label: Text(
                            'Acciones',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: dataSource,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentDataSource extends DataTableSource {
  final List<Map<String, dynamic>> assignments;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  _AssignmentDataSource({
    required this.assignments,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= assignments.length) return null;
    final a = assignments[index];
    final grade = a['grade'] as Grado;
    final category = a['category'] as Category;

    return DataRow(
      cells: [
        DataCell(Text(grade.name)),
        DataCell(Text(category.name)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(a),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(a),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => assignments.length;
  @override
  int get selectedRowCount => 0;
}

class _AssignmentFormDialog extends StatefulWidget {
  final Map<String, dynamic>? assignment;
  const _AssignmentFormDialog({this.assignment});

  @override
  State<_AssignmentFormDialog> createState() => _AssignmentFormDialogState();
}

class _AssignmentFormDialogState extends State<_AssignmentFormDialog> {
  int? _selectedGradeId;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      _selectedGradeId = (widget.assignment!['grade'] as Grado).id;
      _selectedCategoryId = (widget.assignment!['category'] as Category).id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grados = context.watch<GradosProvider>().grados;
    final categories = context.watch<CategoriesProvider>().categories;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 400,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.assignment == null
                      ? 'NUEVA ASIGNACIÓN'
                      : 'EDITAR ASIGNACIÓN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Grado',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                      value: _selectedGradeId,
                      items: grados
                          .map(
                            (g) => DropdownMenuItem(
                              value: g.id,
                              child: Text(g.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedGradeId = val),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                      value: _selectedCategoryId,
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategoryId = val),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _selectedGradeId == null ||
                                    _selectedCategoryId == null
                                ? null
                                : () async {
                                    if (widget.assignment != null) {
                                      // If editing, remove old assignment first
                                      final oldGrade =
                                          widget.assignment!['grade'] as Grado;
                                      final oldCat =
                                          widget.assignment!['category']
                                              as Category;
                                      await context
                                          .read<GradeCategoryProvider>()
                                          .unassign(oldGrade.id!, oldCat.id!);
                                    }
                                    await context
                                        .read<GradeCategoryProvider>()
                                        .assign(
                                          _selectedGradeId!,
                                          _selectedCategoryId!,
                                        );
                                    if (mounted) Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('GUARDAR'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('CANCELAR'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
