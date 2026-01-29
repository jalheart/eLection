import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/l10n/app_localizations.dart';
import '../../../application/providers/settings_provider.dart';
import '../../../application/providers/backup_provider.dart';
import 'package:path/path.dart' as p;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _sloganController;
  late TextEditingController _logoController;
  bool _passRequired = false;
  String _themeColor = '0xFF2196F3'; // Default blue
  String _selectedLanguage = 'es';

  // Preset colors for the theme picker
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _nameController = TextEditingController(text: settings?.name ?? '');
    _sloganController = TextEditingController(text: settings?.slogan ?? '');
    _logoController = TextEditingController(text: settings?.logo ?? '');
    _passRequired = settings?.passRequired ?? true;
    _themeColor = settings?.theme ?? '0xFF2196F3';
    _selectedLanguage = settings?.language ?? 'es';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sloganController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _logoController.text = result.files.single.path!;
      });
    }
  }

  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      try {
        // All file handling logic is now inside SettingsProvider
        await context.read<SettingsProvider>().updateSettings(
          name: _nameController.text,
          slogan: _sloganController.text,
          theme: _themeColor,
          logo: _logoController.text, // Pass original path (absolute if picked, relative if existing)
          passRequired: _passRequired,
        );
        
        if (_selectedLanguage != context.read<SettingsProvider>().settings?.language) {
             await context.read<SettingsProvider>().updateLanguage(_selectedLanguage);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.settingsSaved)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: $e')),
          );
        }
      }
    }
  }

  String _generateRandomCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%&*';
    final rnd = math.Random();
    final length = 5 + rnd.nextInt(4); // 5 to 8
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<void> _showDeleteVotesDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _generateRandomCode();
    final controller = TextEditingController();
    bool isCodeCorrect = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Borrar Votos'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    'Esta acción eliminará todos los votos registrados y restablecerá el estado de los votantes.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Text('Para confirmar, ingrese el siguiente código:'),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el código aquí',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isCodeCorrect = value == code;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: isCodeCorrect
                      ? () async {
                          await context.read<SettingsProvider>().deleteAllVotes();
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Todos los votos han sido eliminados')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('BORRAR TODO'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).primaryColor;

    final List<Widget> sections = [
      _buildSectionCard(
        title: l10n.schoolName,
        icon: Icons.school,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.schoolName,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.business),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _sloganController,
            decoration: InputDecoration(
              labelText: l10n.slogan,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.format_quote),
            ),
          ),
        ],
      ),
      _buildSectionCard(
        title: l10n.themeColor,
        icon: Icons.palette,
        children: [
          // _buildSectionTitle(l10n.themeColor), // Removed as card header already provides title
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                final colorString = '0x${color.value.toRadixString(16).toUpperCase()}';
                final isSelected = _themeColor == colorString;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _themeColor = colorString;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: isSelected
                          ? Border.all(color: Colors.black87, width: 3)
                          : Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                      ],
                    ),
                    width: 44,
                    height: 44,
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 28)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.logo),
          Center(
            child: GestureDetector(
              onTap: _pickLogo,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _logoController.text.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildLogoPreview(_logoController.text),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            l10n.selectLogo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
      _buildSectionCard(
        title: l10n.passRequired,
        icon: Icons.security,
        children: [
          SwitchListTile(
            title: Text(l10n.passRequired, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Increase security by requiring password for voters'),
            value: _passRequired,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _passRequired = value;
              });
            },
          ),
        ],
      ),
      _buildSectionCard(
        title: l10n.language,
        icon: Icons.language,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedLanguage,
            decoration: const InputDecoration(
              labelText: 'Select Language',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.translate),
            ),
            items: const [
              DropdownMenuItem(value: 'es', child: Text('Español 🇪🇸')),
              DropdownMenuItem(value: 'en', child: Text('English 🇺🇸')),
              DropdownMenuItem(value: 'fr', child: Text('Français 🇫🇷')),
              DropdownMenuItem(value: 'pt', child: Text('Português 🇧🇷')),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
          ),
        ],
      ),
      _buildSectionCard(
        title: 'Mantenimiento',
        icon: Icons.build,
        children: [
          const Text(
            'Acciones peligrosas que pueden afectar los datos de la elección.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await context.read<BackupProvider>().exportData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos exportados con éxito')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error exportando: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('EXPORTAR DATOS'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final l10n = AppLocalizations.of(context)!;
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Importar Datos'),
                      content: const Text(
                          'Esta acción reemplazará todos los datos actuales por los del archivo seleccionado. La aplicación se cerrará después de la importación para cargar los nuevos datos. ¿Continuar?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('IMPORTAR')),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      final success = await context.read<BackupProvider>().importData();
                      if (success && context.mounted) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('Importación Exitosa'),
                            content: const Text(
                                'Los datos han sido importados correctamente. Por favor, reinicie la aplicación manualmente para ver los cambios.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () => exit(0),
                                child: const Text('CERRAR APLICACIÓN'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error importando: $e')),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.download_for_offline),
                label: const Text('IMPORTAR DATOS'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _showDeleteVotesDialog,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text('BORRAR TODOS LOS VOTOS', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.red),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 600,
                          mainAxisExtent: isWide ? 380 : 320, // Approximate height adjustment
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: sections.length,
                        itemBuilder: (context, index) => sections[index],
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveSettings,
                          icon: const Icon(Icons.save_rounded),
                          label: Text(l10n.saveSettings,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLogoPreview(String path) {
    if (path.isEmpty) return const SizedBox.shrink();

    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.broken_image));
    }

    if (p.isAbsolute(path)) {
      return Image.file(File(path), fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.broken_image));
    }

    // Use SettingsProvider to resolve relative path
    final resolvedPath = context.read<SettingsProvider>().resolvePath(path);
    if (resolvedPath != null) {
        return Image.file(File(resolvedPath), fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.broken_image));
    }
    
    // Fallback if not resolved (e.g. appDocDir not loaded yet, though simpler to use FutureBuilder if we really want to be safe, but initState loads settings)
    return const SizedBox(
           width: 24, 
           height: 24, 
           child: Center(child: CircularProgressIndicator(strokeWidth: 2))
    );
  }
}
