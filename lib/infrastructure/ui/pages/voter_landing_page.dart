import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/auth_provider.dart';
import '../../../domain/entities/voter.dart';
import '../widgets/admin_layout.dart';
import '../widgets/voting_view.dart';
import 'package:myapp/l10n/app_localizations.dart';

class VoterLandingPage extends StatefulWidget {
  const VoterLandingPage({super.key});

  @override
  State<VoterLandingPage> createState() => _VoterLandingPageState();
}

class _VoterLandingPageState extends State<VoterLandingPage> {
  bool _isVotingStarted = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final voter = authProvider.currentUser as Voter?;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (voter == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return AdminLayout(
      child: (voter.hasVoted)
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: _StatusCard(
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                  message: 'Tu voto ya ha sido registrado correctamente.',
                  subMessage: 'Gracias por participar en la democracia escolar.',
                ),
              ),
            )
          : (_isVotingStarted)
              ? VotingView(
                  voter: voter,
                  onVotesSubmitted: () async {
                    await authProvider.refreshVoter();
                    setState(() {
                      _isVotingStarted = false;
                    });
                    
                    // Automatically logout after 5 seconds
                    Future.delayed(const Duration(seconds: 5), () {
                      if (mounted && authProvider.isAuthenticated) {
                        authProvider.logout();
                      }
                    });
                  },
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.how_to_vote_rounded,
                            size: 80,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          '¡Hola, ${voter.name}!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Bienvenido al sistema de votación escolar eLection.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: 300,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isVotingStarted = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'COMENZAR A VOTAR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
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

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  final String subMessage;

  const _StatusCard({
    required this.icon,
    required this.color,
    required this.message,
    required this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
