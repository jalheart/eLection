import 'package:flutter/material.dart';
import '../widgets/admin_layout.dart';

class AdminLandingPage extends StatelessWidget {
  const AdminLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize, size: 80, color: Colors.blueGrey),
            SizedBox(height: 24),
            Text(
              'Panel de Administración',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Bienvenido al sistema de gestión electoral.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            // Example of a quick action or dashboard item
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _DashboardCard(
                  icon: Icons.people,
                  label: 'Usuarios',
                  color: Colors.blue,
                ),
                _DashboardCard(
                  icon: Icons.settings,
                  label: 'Configuración',
                  color: Colors.orange,
                ),
                _DashboardCard(
                  icon: Icons.how_to_vote,
                  label: 'Elecciones',
                  color: Colors.green,
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
  final IconData icon;
  final String label;
  final Color color;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Future navigation
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
