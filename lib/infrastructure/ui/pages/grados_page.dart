import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/grados_provider.dart';
import '../../../application/providers/categories_provider.dart';
import '../../../application/providers/grade_category_provider.dart';
import '../../../domain/entities/grado.dart';
import '../../../domain/entities/category.dart';
import '../widgets/admin_layout.dart';

import '../widgets/confirm_delete_dialog.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/grado_form_dialog.dart';

class GradosPage extends StatefulWidget {
  const GradosPage({super.key});

  @override
  State<GradosPage> createState() => _GradosPageState();
}

class _GradosPageState extends State<GradosPage> {
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
      context.read<GradosProvider>().loadGrados();
    });
  }

  void _showManageCategoriesDialog(Grado grado) {
    showDialog(
      context: context,
      builder: (context) => _ManageCategoriesDialog(grado: grado),
    );
  }

  void _showGradoForm([Grado? grado]) {
    showDialog(
      context: context,
      builder: (context) => GradoFormDialog(
        grado: grado,
        onSave: (newGrado) {
          context.read<GradosProvider>().saveGrado(newGrado);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Gestión de Grados',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Listado de Grados',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showGradoForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Grado'),
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
              child: Consumer<GradosProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.grados.isEmpty) {
                    return const Center(
                      child: Text('No hay grados registrados.'),
                    );
                  }

                  // Filter and Sort Logic
                  List<Grado> filteredGrados = provider.grados.where((grado) {
                    return grado.name.toLowerCase().contains(_filterText) ||
                        grado.shortName.toLowerCase().contains(_filterText) ||
                        grado.order.toString().contains(_filterText);
                  }).toList();

                  if (_sortColumnIndex != null) {
                    filteredGrados.sort((a, b) {
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

                  if (filteredGrados.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron grados que coincidan.'),
                    );
                  }

                  final dataSource = GradoDataSource(
                    grados: filteredGrados,
                    context: context,
                    onEdit: _showGradoForm,
                    onManageCategories: _showManageCategoriesDialog,
                    onDelete: (grado) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: 'ELIMINAR GRADO',
                          content:
                              '¿Está seguro de eliminar el grado ${grado.name}?',
                          onConfirm: () {
                            provider.deleteGrado(grado.id!);
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

class GradoDataSource extends DataTableSource {
  final List<Grado> grados;
  final BuildContext context;
  final Function(Grado) onEdit;
  final Function(Grado) onManageCategories;
  final Function(Grado) onDelete;

  GradoDataSource({
    required this.grados,
    required this.context,
    required this.onEdit,
    required this.onManageCategories,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= grados.length) return null;
    final grado = grados[index];
    return DataRow(
      onSelectChanged: (value) {
        if (value == true) {
          onEdit(grado);
        }
      },
      cells: [
        DataCell(Text(grado.order.toString())),
        DataCell(Text(grado.name)),
        DataCell(Text(grado.shortName)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.category, color: Colors.orange),
                tooltip: 'Gestionar Categorías',
                onPressed: () => onManageCategories(grado),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(grado),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(grado),
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
  int get rowCount => grados.length;

  @override
  int get selectedRowCount => 0;
}

class _ManageCategoriesDialog extends StatefulWidget {
  final Grado grado;
  const _ManageCategoriesDialog({required this.grado});

  @override
  State<_ManageCategoriesDialog> createState() =>
      _ManageCategoriesDialogState();
}

class _ManageCategoriesDialogState extends State<_ManageCategoriesDialog> {
  List<Category> _assignedCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedCategories();
  }

  Future<void> _loadAssignedCategories() async {
    setState(() => _isLoading = true);
    final categories = await context
        .read<GradeCategoryProvider>()
        .getCategoriesByGrade(widget.grado.id!);
    setState(() {
      _assignedCategories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = context.watch<CategoriesProvider>().categories;

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
                  'CATEGORÍAS PARA ${widget.grado.name.toUpperCase()}',
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
                          const Text(
                            'Seleccione las categorías asignadas:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: allCategories.length,
                              itemBuilder: (context, index) {
                                final category = allCategories[index];
                                final isAssigned = _assignedCategories.any(
                                  (c) => c.id == category.id,
                                );

                                return CheckboxListTile(
                                  title: Text(
                                    category.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  value: isAssigned,
                                  dense: true,
                                  onChanged: (bool? value) async {
                                    if (value == true) {
                                      await context
                                          .read<GradeCategoryProvider>()
                                          .assign(
                                            widget.grado.id!,
                                            category.id!,
                                          );
                                    } else {
                                      await context
                                          .read<GradeCategoryProvider>()
                                          .unassign(
                                            widget.grado.id!,
                                            category.id!,
                                          );
                                    }
                                    _loadAssignedCategories();
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
                              child: const Text('CERRAR'),
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
