import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:election/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/candidates_provider.dart';
import '../../../domain/entities/candidate.dart';

class CandidateFormDialog extends StatefulWidget {
  final Candidate? candidate;
  final String categoryName;
  final int categoryId;
  final Function(Candidate) onSave;

  const CandidateFormDialog({
    super.key,
    this.candidate,
    required this.categoryName,
    required this.categoryId,
    required this.onSave,
  });

  @override
  State<CandidateFormDialog> createState() => _CandidateFormDialogState();
}

class _CandidateFormDialogState extends State<CandidateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.candidate?.name ?? '');
    _imagePath = widget.candidate?.picture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
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
                  '${widget.candidate == null ? l10n.newCandidate.toUpperCase() : l10n.editCandidate.toUpperCase()} - ${widget.categoryName.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                          labelText: l10n.candidateName,
                          isDense: true,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.error : null,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 180,
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey[50],
                                ),
                                child: _imagePath != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Builder(
                                          builder: (context) {
                                            final isAbsolute = File(
                                              _imagePath!,
                                            ).isAbsolute;
                                            final resolvedPath = isAbsolute
                                                ? _imagePath
                                                : context
                                                      .read<
                                                        CandidatesProvider
                                                      >()
                                                      .resolvePath(_imagePath);

                                            if (resolvedPath != null) {
                                              if (resolvedPath.startsWith(
                                                    'http',
                                                  ) ||
                                                  resolvedPath.startsWith(
                                                    'assets',
                                                  )) {
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
                                            return const Icon(
                                              Icons.image,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.image,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            l10n.selectPicture,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onSave(
                                    Candidate(
                                      id: widget.candidate?.id,
                                      name: _nameController.text,
                                      categoryId: widget.categoryId,
                                      picture: _imagePath,
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
