import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/grados_provider.dart';
import '../../../domain/entities/grado.dart';
import '../widgets/admin_layout.dart';

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

  void _showGradoForm([Grado? grado]) {
    final nameController = TextEditingController(text: grado?.name ?? '');
    final shortNameController = TextEditingController(
      text: grado?.shortName ?? '',
    );
    final orderController = TextEditingController(
      text: grado?.order.toString() ?? '0',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                // Title Bar
                Container(
                  height: 48,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    grado == null ? 'NUEVO GRADO' : 'EDITAR GRADO',
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
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: shortNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Corto',
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: orderController,
                        decoration: const InputDecoration(
                          labelText: 'Orden',
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Justified Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final newGrado = Grado(
                                  id: grado?.id,
                                  name: nameController.text,
                                  shortName: shortNameController.text,
                                  order:
                                      int.tryParse(orderController.text) ?? 0,
                                );
                                context.read<GradosProvider>().saveGrado(
                                  newGrado,
                                );
                                Navigator.pop(context);
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
            TextField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
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
                    onDelete: (grado) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 350,
                              padding: EdgeInsets.zero,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title Bar
                                  Container(
                                    height: 48,
                                    width: double.infinity,
                                    color: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'ELIMINAR GRADO',
                                      style: TextStyle(
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
                                        Text(
                                          '¿Está seguro de eliminar el grado ${grado.name}?',
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  provider.deleteGrado(
                                                    grado.id!,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red.shade700,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: const Text('ELIMINAR'),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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

class GradoDataSource extends DataTableSource {
  final List<Grado> grados;
  final BuildContext context;
  final Function(Grado) onEdit;
  final Function(Grado) onDelete;

  GradoDataSource({
    required this.grados,
    required this.context,
    required this.onEdit,
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
