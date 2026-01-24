import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/settings_provider.dart';
import '../../../application/providers/auth_provider.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AdminLayout({super.key, required this.child, this.title = ''});

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
                        if (Navigator.canPop(context))
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        if (settings?.logo != null && settings!.logo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/${settings.logo}',
                              height: 30,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.school,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                            ),
                          )
                        else
                          const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 30,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          title.isNotEmpty
                              ? title
                              : (settings?.name ?? 'Cargando...'),
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
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                const Text(
                  'Listo',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                const Text(
                  'Software desarrollado por Antigravity',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final user = auth.currentUser;
                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          auth.logout();
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Cerrar sesión'),
                            ],
                          ),
                        ),
                      ],
                      offset: const Offset(0, -50), // Show menu above the bar
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          'Usuario: ${user?.name ?? 'Invitado'}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
