import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import '../../../application/providers/settings_provider.dart';
import '../../../application/providers/auth_provider.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/voter.dart';
import 'package:election/l10n/app_localizations.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AdminLayout({super.key, required this.child, this.title = '', this.actions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                            child: Builder(
                              builder: (context) {
                                final logo = settings.logo;
                                if (logo.startsWith('assets/')) {
                                  return Image.asset(logo, height: 30, errorBuilder: (_,__,___) => const Icon(Icons.school, color: Colors.white, size: 30));
                                } else if (p.isAbsolute(logo)) {
                                  return Image.file(File(logo), height: 30, errorBuilder: (_,__,___) => const Icon(Icons.school, color: Colors.white, size: 30));
                                } else {
                                  final resolved = settingsProvider.resolvePath(logo);
                                   if (resolved != null) {
                                      return Image.file(File(resolved), height: 30, errorBuilder: (_,__,___) => const Icon(Icons.school, color: Colors.white, size: 30));
                                   } else {
                                      return const Icon(Icons.school, color: Colors.white, size: 30);
                                   }
                                }
                              }
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
                    // Right: Software Name and Version + Actions
                    Row(
                      children: [
                        if (actions != null) ...actions!,
                        if (actions != null) const SizedBox(width: 16),
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
                Consumer<SettingsProvider>(
                  builder: (context, provider, _) {
                    return Text(
                      (provider.settings?.slogan.isNotEmpty == true)
                          ? provider.settings!.slogan
                          : l10n.ready,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  l10n.developedBy('Jaime Hernández en Antigravity'),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Consumer<SettingsProvider>(
                  builder: (context, settingsProvider, _) {
                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        settingsProvider.updateLanguage(value);
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'es',
                          child: Text('Español'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'en',
                          child: Text('English'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'fr',
                          child: Text('Français'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'pt',
                          child: Text('Português'),
                        ),
                      ],
                      offset: const Offset(0, -180),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              size: 14,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (settingsProvider.settings?.language ?? 'es')
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final user = auth.currentUser;
                    final l10n = AppLocalizations.of(context)!;
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
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.logout,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.logout),
                            ],
                          ),
                        ),
                      ],
                      offset: const Offset(0, -50), // Show menu above the bar
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Builder(
                          builder: (context) {
                            String displayName = l10n.guest;
                            if (auth.isAdmin) {
                              displayName = (user as User).name;
                            } else if (auth.isVoter) {
                              displayName = (user as Voter).name;
                            }
                            return Text(
                              '${l10n.username}: $displayName',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            );
                          },
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
