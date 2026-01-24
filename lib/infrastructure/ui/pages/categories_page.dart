import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/categories_provider.dart';
import '../../../domain/entities/category.dart';
import '../widgets/admin_layout.dart';

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
    });
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
    return AdminLayout(
      title: 'Gestión de Categorías',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Listado de Categorías',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCategoryForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Categoría'),
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
                    return const Center(
                      child: Text('No hay categorías registradas.'),
                    );
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
                    return const Center(
                      child: Text(
                        'No se encontraron categorías que coincidan.',
                      ),
                    );
                  }

                  final dataSource = CategoryDataSource(
                    categories: filteredCategories,
                    context: context,
                    onEdit: _showCategoryForm,
                    onDelete: (category) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: 'ELIMINAR CATEGORÍA',
                          content:
                              '¿Está seguro de eliminar la categoría ${category.name}?',
                          onConfirm: () {
                            provider.deleteCategory(category.id!);
                          },
                        ),
                      );
                    },
                  );

                  return Container(
                    color: Colors.white,
                    child: PaginatedDataTable2(
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
                          label: const Text(
                            'Orden',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          label: const Text(
                            'Nombre',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          label: const Text(
                            'Nombre Corto',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          size: ColumnSize.M,
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

class CategoryDataSource extends DataTableSource {
  final List<Category> categories;
  final BuildContext context;
  final Function(Category) onEdit;
  final Function(Category) onDelete;

  CategoryDataSource({
    required this.categories,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
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
