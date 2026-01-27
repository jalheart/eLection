import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/application/providers/voters_provider.dart';
import 'package:myapp/application/providers/grados_provider.dart';
import 'package:myapp/domain/entities/voter.dart';
import 'package:myapp/domain/entities/grado.dart';
import 'package:myapp/infrastructure/ui/widgets/admin_layout.dart';
import 'package:myapp/infrastructure/ui/widgets/custom_search_bar.dart';
import 'package:myapp/infrastructure/ui/widgets/voter_form_dialog.dart';
import 'package:myapp/infrastructure/ui/widgets/confirm_delete_dialog.dart';

class VotersPage extends StatefulWidget {
  const VotersPage({super.key});

  @override
  State<VotersPage> createState() => _VotersPageState();
}

class _VotersPageState extends State<VotersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedGradeId;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GradosProvider>().loadGrados();
      context.read<VotersProvider>().loadVoters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showVoterForm([Voter? voter]) {
    final grades = context.read<GradosProvider>().grados;
    showDialog(
      context: context,
      builder: (context) => VoterFormDialog(
        voter: voter,
        grades: grades,
        initialGradeId: _selectedGradeId,
        onSave: (newVoter) {
          context.read<VotersProvider>().saveVoter(newVoter);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.voterSaved)),
          );
        },
      ),
    );
  }

  Future<void> _importVoters() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && mounted) {
      final file = io.File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final votersProvider = context.read<VotersProvider>();
      final gradesProvider = context.read<GradosProvider>();

      List<Voter> importedVoters = [];

      for (var table in excel.tables.keys) {
        final rows = excel.tables[table]!.rows;
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length < 3) continue;

          final name = row[0]?.value?.toString() ?? '';
          final documentId = row[1]?.value?.toString() ?? '';
          final gradeName = row[2]?.value?.toString() ?? '';

          if (name.isEmpty || documentId.isEmpty) continue;

          final grade = gradesProvider.grados.firstWhere(
            (g) => g.name.toLowerCase() == gradeName.toLowerCase(),
            orElse: () => gradesProvider.grados.first,
          );

          importedVoters.add(
            Voter(name: name, documentId: documentId, gradeId: grade.id!),
          );
        }
      }

      if (importedVoters.isNotEmpty) {
        await votersProvider.importVoters(importedVoters);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.votersImported)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdminLayout(
      title: l10n.manageVoters,
      child: Consumer2<VotersProvider, GradosProvider>(
        builder: (context, votersProvider, gradesProvider, child) {
          if (votersProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredVoters = votersProvider.voters.where((v) {
            final matchesSearch =
                v.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                v.documentId.contains(_searchQuery);
            final matchesGrade =
                _selectedGradeId == null || v.gradeId == _selectedGradeId;
            return matchesSearch && matchesGrade;
          }).toList();

          if (_sortColumnIndex != null) {
            filteredVoters.sort((a, b) {
              int compareResult = 0;
              switch (_sortColumnIndex) {
                case 0:
                  compareResult = a.name.compareTo(b.name);
                  break;
                case 1:
                  compareResult = a.documentId.compareTo(b.documentId);
                  break;
                case 2:
                  final gradeA = gradesProvider.grados.firstWhere(
                    (g) => g.id == a.gradeId,
                    orElse: () => Grado(name: '?', shortName: '?', order: 0),
                  );
                  final gradeB = gradesProvider.grados.firstWhere(
                    (g) => g.id == b.gradeId,
                    orElse: () => Grado(name: '?', shortName: '?', order: 0),
                  );
                  compareResult = gradeA.name.compareTo(gradeB.name);
                  break;
              }
              return _isAscending ? compareResult : -compareResult;
            });
          }

          final dataSource = VoterDataSource(
            voters: filteredVoters,
            grades: gradesProvider.grados,
            context: context,
            onEdit: _showVoterForm,
            onDelete: (voter) {
              showDialog(
                context: context,
                builder: (context) => ConfirmDeleteDialog(
                  title: l10n.deleteVoter,
                  content: l10n.deleteVoterConfirm(voter.name),
                  onConfirm: () => votersProvider.deleteVoter(voter.id!),
                ),
              );
            },
          );

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.voters, // "Votantes"
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _importVoters,
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.importVoters),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showVoterForm(),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.newVoter),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        controller: _searchController,
                        hintText: l10n.search,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 250,
                      child: DropdownButtonFormField<int>(
                        value: _selectedGradeId,
                        decoration: InputDecoration(
                          labelText: l10n.grades,
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.noData),
                          ),
                          ...gradesProvider.grados.map(
                            (g) => DropdownMenuItem(
                              value: g.id,
                              child: Text(g.name),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedGradeId = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
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
                            l10n.documentId,
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
                            l10n.grades,
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
                          fixedWidth: 120,
                        ),
                      ],
                      source: dataSource,
                      empty: Center(child: Text(l10n.noVoters)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: l10n.deleteAllVoters,
                          content: l10n.deleteAllVotersConfirm,
                          onConfirm: () => votersProvider.deleteAllVoters(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: Text(
                      l10n.deleteAllVoters.toUpperCase(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VoterDataSource extends DataTableSource {
  final List<Voter> voters;
  final List<Grado> grades;
  final BuildContext context;
  final Function(Voter) onEdit;
  final Function(Voter) onDelete;

  VoterDataSource({
    required this.voters,
    required this.grades,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= voters.length) return null;
    final voter = voters[index];
    final grade = grades.firstWhere(
      (g) => g.id == voter.gradeId,
      orElse: () => Grado(name: '?', shortName: '?', order: 0),
    );

    return DataRow(
      onSelectChanged: (value) {
        if (value == true) {
          onEdit(voter);
        }
      },
      cells: [
        DataCell(Text(voter.name)),
        DataCell(Text(voter.documentId)),
        DataCell(Text(grade.name)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(voter),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(voter),
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
  int get rowCount => voters.length;

  @override
  int get selectedRowCount => 0;
}
