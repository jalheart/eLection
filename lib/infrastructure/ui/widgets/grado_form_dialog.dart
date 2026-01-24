import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/grado.dart';

class GradoFormDialog extends StatefulWidget {
  final Grado? grado;
  final Function(Grado) onSave;

  const GradoFormDialog({super.key, this.grado, required this.onSave});

  @override
  State<GradoFormDialog> createState() => _GradoFormDialogState();
}

class _GradoFormDialogState extends State<GradoFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.grado?.name ?? '');
    _shortNameController = TextEditingController(
      text: widget.grado?.shortName ?? '',
    );
    _orderController = TextEditingController(
      text: widget.grado?.order.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortNameController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.grado == null ? 'NUEVO GRADO' : 'EDITAR GRADO',
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _shortNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Corto',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _orderController,
                      decoration: const InputDecoration(
                        labelText: 'Orden',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final newGrado = Grado(
                                id: widget.grado?.id,
                                name: _nameController.text,
                                shortName: _shortNameController.text,
                                order: int.tryParse(_orderController.text) ?? 0,
                              );
                              widget.onSave(newGrado);
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
    );
  }
}
