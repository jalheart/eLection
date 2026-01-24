import 'package:flutter/material.dart';
import '../widgets/admin_layout.dart';
import 'grados_page.dart';
import 'categories_page.dart';

class AdminLandingPage extends StatelessWidget {
  const AdminLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Panel de Administración',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bienvenido al sistema de gestión electoral.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Example of a quick action or dashboard item
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                const _DashboardCard(
                  image: 'assets/images/estudiante.png',
                  label: 'Estudiantes',
                ),
                _DashboardCard(
                  image: 'assets/images/course.png',
                  label: 'Grados',
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
                  label: 'Categorías',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                ),
                const _DashboardCard(
                  image: 'assets/images/course-categories.png',
                  label: 'Categorías/Grados',
                ),
                const _DashboardCard(
                  image: 'assets/images/candidates.png',
                  label: 'Candidatos',
                ),
                const _DashboardCard(
                  image: 'assets/images/settings.png',
                  label: 'Configuración',
                ),
                const _DashboardCard(
                  image: 'assets/images/resultados.png',
                  label: 'Resultados',
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
