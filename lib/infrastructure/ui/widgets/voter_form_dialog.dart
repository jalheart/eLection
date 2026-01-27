import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import '../../../domain/entities/voter.dart';
import '../../../domain/entities/grado.dart';

class VoterFormDialog extends StatefulWidget {
  final Voter? voter;
  final List<Grado> grades;
  final int? initialGradeId;
  final Function(Voter) onSave;

  const VoterFormDialog({
    super.key,
    this.voter,
    required this.grades,
    this.initialGradeId,
    required this.onSave,
  });

  @override
  State<VoterFormDialog> createState() => _VoterFormDialogState();
}

class _VoterFormDialogState extends State<VoterFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _documentController;
  int? _selectedGradeId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.voter?.name ?? '');
    _documentController = TextEditingController(
      text: widget.voter?.documentId ?? '',
    );
    _selectedGradeId = widget.voter?.gradeId ?? widget.initialGradeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  widget.voter == null
                      ? l10n.newVoter.toUpperCase()
                      : l10n.editVoter.toUpperCase(),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          isDense: true,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.error : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _documentController,
                        decoration: InputDecoration(
                          labelText: l10n.documentId,
                          isDense: true,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.error : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedGradeId,
                        decoration: InputDecoration(
                          labelText: l10n.grades,
                          isDense: true,
                          border: const UnderlineInputBorder(),
                        ),
                        items: widget.grades.map((grade) {
                          return DropdownMenuItem(
                            value: grade.id,
                            child: Text(grade.name),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedGradeId = value),
                        validator: (value) => value == null ? l10n.error : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onSave(
                                    Voter(
                                      id: widget.voter?.id,
                                      name: _nameController.text,
                                      documentId: _documentController.text,
                                      gradeId: _selectedGradeId!,
                                      hasVoted: widget.voter?.hasVoted ?? false,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(l10n.save.toUpperCase()),
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
                              child: Text(l10n.cancel.toUpperCase()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
