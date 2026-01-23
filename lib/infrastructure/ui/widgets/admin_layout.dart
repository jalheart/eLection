import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/settings_provider.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AdminLayout({
    super.key,
    required this.child,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title Bar (50px)
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) {
              final settings = settingsProvider.settings;
              return Container(
                height: 50,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Logo and Institution Name
                    Row(
                      children: [
                        if (settings?.logo != null && settings!.logo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/${settings.logo}',
                              height: 30,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.school, color: Colors.white, size: 30),
                            ),
                          )
                        else
                          const Icon(Icons.school, color: Colors.white, size: 30),
                        Text(
                          settings?.name ?? 'Cargando...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Right: Software Name and Version
                    const Row(
                      children: [
                        Text(
                          'eLection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'v1.0.0',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Main Content Area
          Expanded(child: child),
          // Status Bar (24px)
          Container(
            height: 24,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Listo',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Spacer(),
                Text(
                  'Software desarrollado por Antigravity',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
