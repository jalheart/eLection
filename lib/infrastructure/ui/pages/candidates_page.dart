import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:election/l10n/app_localizations.dart';
import '../../../application/providers/candidates_provider.dart';
import '../../../application/providers/categories_provider.dart';
import '../../../domain/entities/candidate.dart';
import '../widgets/admin_layout.dart';
import '../widgets/candidate_form_dialog.dart';
import '../widgets/confirm_delete_dialog.dart';

class CandidatesPage extends StatefulWidget {
  const CandidatesPage({super.key});

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  int? _expandedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesProvider>().loadCategories().then((_) {
        final categories = context.read<CategoriesProvider>().categories;
        if (categories.isNotEmpty) {
          setState(() {
            _expandedCategoryId = categories.first.id;
          });
        }
      });
      context.read<CandidatesProvider>().loadCandidates();
    });
  }

  void _showCandidateForm(int categoryId, [Candidate? candidate]) {
    final categories = context.read<CategoriesProvider>().categories;
    final category = categories.firstWhere((c) => c.id == categoryId);

    showDialog(
      context: context,
      builder: (context) => CandidateFormDialog(
        candidate: candidate,
        categoryName: category.name,
        categoryId: categoryId,
        onSave: (newCandidate) {
          context.read<CandidatesProvider>().saveCandidate(newCandidate);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdminLayout(
      title: l10n.manageCandidates,
      child: Consumer2<CategoriesProvider, CandidatesProvider>(
        builder: (context, catProvider, candProvider, child) {
          if (catProvider.isLoading || candProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = catProvider.categories;
          final candidates = candProvider.candidates;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryCandidates = candidates
                  .where((c) => c.categoryId == category.id)
                  .toList();

              return Card(
                margin: const EdgeInsets.only(bottom: 4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: ExpansionTile(
                  key: Key(
                    '${category.id}_${_expandedCategoryId == category.id}',
                  ),
                  initiallyExpanded: _expandedCategoryId == category.id,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedCategoryId = expanded ? category.id : null;
                    });
                  },
                  leading: const Icon(Icons.person_outline),
                  title: Row(
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          categoryCandidates.length.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            ...categoryCandidates.map(
                              (candidate) => _CandidateCard(
                                candidate: candidate,
                                onEdit: () =>
                                    _showCandidateForm(category.id!, candidate),
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmDeleteDialog(
                                      title: l10n.deleteCandidate,
                                      content: l10n.deleteCandidateConfirm(
                                        candidate.name,
                                      ),
                                      onConfirm: () => candProvider
                                          .deleteCandidate(candidate.id!),
                                    ),
                                  );
                                },
                              ),
                            ),
                            _AddCandidateCard(
                              onTap: () => _showCandidateForm(category.id!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CandidateCard({
    required this.candidate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  candidate.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 8, bottom: 48),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Builder(
                          builder: (context) {
                            final resolvedPath = context
                                .read<CandidatesProvider>()
                                .resolvePath(candidate.picture);
                            if (resolvedPath != null) {
                              if (resolvedPath.startsWith('http') ||
                                  resolvedPath.startsWith('assets')) {
                                return Image.network(
                                  resolvedPath,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.file(
                                  File(resolvedPath),
                                  fit: BoxFit.cover,
                                );
                              }
                            }
                            return Center(
                              child: Text(
                                candidate.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: _ActionButton(
              icon: Icons.edit,
              color: Colors.blue,
              onPressed: onEdit,
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: _ActionButton(
              icon: Icons.delete,
              color: Colors.red,
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _AddCandidateCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCandidateCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 310,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}
