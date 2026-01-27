import 'package:flutter/material.dart';
import '../widgets/admin_layout.dart';
import 'grados_page.dart';
import 'categories_page.dart';
import 'candidates_page.dart';
import 'package:myapp/l10n/app_localizations.dart';

class AdminLandingPage extends StatelessWidget {
  const AdminLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdminLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard_customize,
              size: 80,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.adminPanel,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.welcomeMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Example of a quick action or dashboard item
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _DashboardCard(
                  image: 'assets/images/estudiante.png',
                  label: l10n.students,
                ),
                _DashboardCard(
                  image: 'assets/images/course.png',
                  label: l10n.grades,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GradosPage(),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  image: 'assets/images/categories.png',
                  label: l10n.categories,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  image: 'assets/images/candidates.png',
                  label: l10n.candidates,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CandidatesPage(),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  image: 'assets/images/settings.png',
                  label: l10n.settings,
                ),
                _DashboardCard(
                  image: 'assets/images/resultados.png',
                  label: l10n.results,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap;

  const _DashboardCard({required this.image, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 150,
          height: 160,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 80, width: 80, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
