import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/categories_provider.dart';
import '../../../application/providers/grados_provider.dart';
import '../../../application/providers/grade_category_provider.dart';
import '../../../application/providers/candidates_provider.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/grado.dart';
import '../widgets/admin_layout.dart';
import '../widgets/category_candidates_dialog.dart';

import '../widgets/confirm_delete_dialog.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_form_dialog.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
      context.read<CategoriesProvider>().loadCategories();
      context.read<GradosProvider>().loadGrados();
      context.read<GradeCategoryProvider>().loadAssignments();
      context.read<CandidatesProvider>().loadCandidates();
    });
  }

  void _showManageGradesDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => _ManageGradesDialog(category: category),
    );
  }

  void _showCategoryForm([Category? category]) {
    showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(
        category: category,
        onSave: (newCategory) {
          context.read<CategoriesProvider>().saveCategory(newCategory);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdminLayout(
      title: l10n.manageCategoriesTitle,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.categoryList,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCategoryForm(),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newCategory),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar
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
              child: Consumer<CategoriesProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.categories.isEmpty) {
                    return Center(child: Text(l10n.noCategories));
                  }

                  // Filter and Sort Logic
                  List<Category> filteredCategories = provider.categories.where(
                    (category) {
                      return category.name.toLowerCase().contains(
                            _filterText,
                          ) ||
                          category.shortName.toLowerCase().contains(
                            _filterText,
                          ) ||
                          category.order.toString().contains(_filterText);
                    },
                  ).toList();

                  if (_sortColumnIndex != null) {
                    filteredCategories.sort((a, b) {
                      int compareResult = 0;
                      switch (_sortColumnIndex) {
                        case 0:
                          compareResult = a.order.compareTo(b.order);
                          break;
                        case 1:
                          compareResult = a.name.compareTo(b.name);
                          break;
                        case 2:
                          compareResult = a.shortName.compareTo(b.shortName);
                          break;
                      }
                      return _isAscending ? compareResult : -compareResult;
                    });
                  }

                  if (filteredCategories.isEmpty) {
                    return Center(child: Text(l10n.noCategoriesFound));
                  }

                  final dataSource = CategoryDataSource(
                    categories: filteredCategories,
                    context: context,
                    onEdit: _showCategoryForm,
                    onManageGrades: _showManageGradesDialog,
                    onDelete: (category) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: l10n.deleteCategoryTitle,
                          content: l10n.deleteCategoryConfirm(category.name),
                          onConfirm: () async {
                            try {
                              await provider.deleteCategory(category.id!);
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.deleteCategoryError),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
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
                      availableRowsPerPage: const [10, 20, 50],
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
                          label: Text(
                            l10n.order,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          size: ColumnSize.S,
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _isAscending = ascending;
                            });
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            l10n.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          size: ColumnSize.L,
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _isAscending = ascending;
                            });
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            l10n.shortName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          size: ColumnSize.M,
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _isAscending = ascending;
                            });
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            l10n.actions,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

class CategoryDataSource extends DataTableSource {
  final List<Category> categories;
  final BuildContext context;
  final Function(Category) onEdit;
  final Function(Category) onManageGrades;
  final Function(Category) onDelete;

  CategoryDataSource({
    required this.categories,
    required this.context,
    required this.onEdit,
    required this.onManageGrades,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    final l10n = AppLocalizations.of(context)!;
    if (index >= categories.length) return null;
    final category = categories[index];
    return DataRow(
      onSelectChanged: (value) {
        if (value == true) {
          onEdit(category);
        }
      },
      cells: [
        DataCell(Text(category.order.toString())),
        DataCell(Text(category.name)),
        DataCell(Text(category.shortName)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Consumer<GradeCategoryProvider>(
                  builder: (context, gcProvider, _) {
                    final count = gcProvider.getGradeCountForCategory(
                      category.id!,
                    );
                    return Badge(
                      label: Text(count.toString()),
                      backgroundColor: Colors.orange,
                      isLabelVisible: count > 0,
                      child: const Icon(Icons.school, color: Colors.orange),
                    );
                  },
                ),
                tooltip: l10n.manageGrades,
                onPressed: () => onManageGrades(category),
              ),
              IconButton(
                icon: Consumer<CandidatesProvider>(
                  builder: (context, candProvider, _) {
                    final count = candProvider.candidates
                        .where((c) => c.categoryId == category.id)
                        .length;
                    return Badge(
                      label: Text(count.toString()),
                      backgroundColor: Colors.teal,
                      isLabelVisible: count > 0,
                      child: const Icon(Icons.people, color: Colors.teal),
                    );
                  },
                ),
                tooltip: l10n.manageCandidates,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CategoryCandidatesDialog(category: category),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(category),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(category),
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
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}

class _ManageGradesDialog extends StatefulWidget {
  final Category category;
  const _ManageGradesDialog({required this.category});

  @override
  State<_ManageGradesDialog> createState() => _ManageGradesDialogState();
}

class _ManageGradesDialogState extends State<_ManageGradesDialog> {
  List<Grado> _assignedGrades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedGrades();
  }

  Future<void> _loadAssignedGrades() async {
    setState(() => _isLoading = true);
    final grades = await context
        .read<GradeCategoryProvider>()
        .getGradesByCategory(widget.category.id!);
    setState(() {
      _assignedGrades = grades;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allGrades = context.watch<GradosProvider>().grados;

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
                  l10n.gradesFor(widget.category.name.toUpperCase()),
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.selectAssignedGrades,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: allGrades.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        l10n.noGrades,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: allGrades.length,
                                    itemBuilder: (context, index) {
                                      final grade = allGrades[index];
                                      final isAssigned = _assignedGrades.any(
                                        (g) => g.id == grade.id,
                                      );

                                      return CheckboxListTile(
                                        title: Text(
                                          grade.name,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        value: isAssigned,
                                        dense: true,
                                        onChanged: (bool? value) async {
                                          if (value == true) {
                                            await context
                                                .read<GradeCategoryProvider>()
                                                .assign(
                                                  grade.id!,
                                                  widget.category.id!,
                                                );
                                          } else {
                                            await context
                                                .read<GradeCategoryProvider>()
                                                .unassign(
                                                  grade.id!,
                                                  widget.category.id!,
                                                );
                                          }
                                          _loadAssignedGrades();
                                        },
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(l10n.close),
                            ),
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
