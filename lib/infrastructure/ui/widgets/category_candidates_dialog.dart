import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:election/l10n/app_localizations.dart';
import '../../../application/providers/candidates_provider.dart';
import '../../../domain/entities/candidate.dart';
import '../../../domain/entities/category.dart';
import 'candidate_form_dialog.dart';
import 'confirm_delete_dialog.dart';

class CategoryCandidatesDialog extends StatelessWidget {
  final Category category;

  const CategoryCandidatesDialog({super.key, required this.category});

  void _showCandidateForm(BuildContext context, [Candidate? candidate]) {
    showDialog(
      context: context,
      builder: (context) => CandidateFormDialog(
        candidate: candidate,
        categoryName: category.name,
        categoryId: category.id!,
        onSave: (newCandidate) {
          context.read<CandidatesProvider>().saveCandidate(newCandidate);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 800,
          height: 600,
          child: Column(
            children: [
              Container(
                height: 48,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.candidates.toUpperCase()} - ${category.name.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<CandidatesProvider>(
                  builder: (context, candProvider, child) {
                    final categoryCandidates = candProvider.candidates
                        .where((c) => c.categoryId == category.id)
                        .toList();

                    if (categoryCandidates.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_off_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noCandidates,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _showCandidateForm(context),
                              icon: const Icon(Icons.add),
                              label: Text(l10n.newCandidate.toUpperCase()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 180 / 310,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: categoryCandidates.length + 1,
                      itemBuilder: (context, index) {
                        if (index == categoryCandidates.length) {
                          return _AddCandidateCard(
                            onTap: () => _showCandidateForm(context),
                          );
                        }
                        final candidate = categoryCandidates[index];
                        return _CandidateCard(
                          candidate: candidate,
                          onEdit: () => _showCandidateForm(context, candidate),
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmDeleteDialog(
                                title: l10n.deleteCandidate,
                                content: l10n.deleteCandidateConfirm(
                                  candidate.name,
                                ),
                                onConfirm: () =>
                                    candProvider.deleteCandidate(candidate.id!),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
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
