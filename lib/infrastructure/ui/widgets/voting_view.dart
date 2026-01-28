import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/providers/voting_provider.dart';
import '../../../application/providers/candidates_provider.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/candidate.dart';
import '../../../domain/entities/voter.dart';
import 'package:myapp/l10n/app_localizations.dart';

class VotingView extends StatefulWidget {
  final Voter voter;
  final VoidCallback onVotesSubmitted;

  const VotingView({
    super.key,
    required this.voter,
    required this.onVotesSubmitted,
  });

  @override
  State<VotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<VotingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VotingProvider>().initVoting(widget.voter);
      context.read<CandidatesProvider>().loadCandidates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();
    final candidatesProvider = context.watch<CandidatesProvider>();

    if (votingProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (votingProvider.categories.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles para tu grado.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 800;

        if (isSmallScreen) {
          return _MobileVotingView(
            voter: widget.voter,
            onVotesSubmitted: widget.onVotesSubmitted,
          );
        } else {
          return _DesktopVotingView(
            voter: widget.voter,
            onVotesSubmitted: widget.onVotesSubmitted,
          );
        }
      },
    );
  }
}

class _DesktopVotingView extends StatelessWidget {
  final Voter voter;
  final VoidCallback onVotesSubmitted;

  const _DesktopVotingView({
    required this.voter,
    required this.onVotesSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: votingProvider.categories.length,
          itemBuilder: (context, index) {
            final category = votingProvider.categories[index];
            final candidates = votingProvider.candidatesByCategory[category.id] ?? [];
            return _CategorySection(
              category: category,
              candidates: candidates,
              selectedCandidateId: votingProvider.selectedCandidates[category.id],
              onSelect: (candidateId) {
                votingProvider.selectCandidate(category.id!, candidateId);
              },
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: _SubmitButton(voter: voter, onVotesSubmitted: onVotesSubmitted),
        ),
      ],
    );
  }
}

class _MobileVotingView extends StatefulWidget {
  final Voter voter;
  final VoidCallback onVotesSubmitted;

  const _MobileVotingView({
    required this.voter,
    required this.onVotesSubmitted,
  });

  @override
  State<_MobileVotingView> createState() => _MobileVotingViewState();
}

class _MobileVotingViewState extends State<_MobileVotingView> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();
    final categories = votingProvider.categories;

    return Column(
      children: [
        Expanded(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            steps: categories.map((cat) {
              final candidates = votingProvider.candidatesByCategory[cat.id] ?? [];
              final isStepSelected = votingProvider.selectedCandidates[cat.id] != null;
              
              return Step(
                title: Text(cat.shortName, style: const TextStyle(fontSize: 10)),
                isActive: _currentStep >= categories.indexOf(cat),
                state: isStepSelected ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    _CategoryHeader(title: cat.name),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: candidates.map((cand) => _CandidateCard(
                        candidate: cand,
                        isSelected: votingProvider.selectedCandidates[cat.id] == cand.id,
                        onTap: () {
                          votingProvider.selectCandidate(cat.id!, cand.id!);
                          if (_currentStep < categories.length - 1) {
                            setState(() => _currentStep++);
                          }
                        },
                      )).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (_currentStep == categories.length - 1)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _SubmitButton(voter: widget.voter, onVotesSubmitted: widget.onVotesSubmitted),
          ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final Category category;
  final List<Candidate> candidates;
  final int? selectedCandidateId;
  final Function(int) onSelect;

  const _CategorySection({
    required this.category,
    required this.candidates,
    required this.selectedCandidateId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CategoryHeader(title: category.name),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: candidates.map(( cand) => _CandidateCard(
              candidate: cand,
              isSelected: cand.id == selectedCandidateId,
              onTap: () => onSelect(cand.id!),
            )).toList(),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;
  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          const Icon(Icons.person_pin_rounded, size: 18),
          const SizedBox(width: 8),
          Text(
            'Votar por: $title',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final bool isSelected;
  final VoidCallback onTap;

  const _CandidateCard({
    required this.candidate,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final candidatesProvider = context.watch<CandidatesProvider>();
    final theme = Theme.of(context);
    final isVotoBlanco = candidate.name.toUpperCase().contains('VOTO EN BLANCO');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 130,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? theme.primaryColor : Colors.grey.shade300,
              width: isSelected ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                   decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                  ),
                  child: _buildImage(candidatesProvider),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                color: Colors.white,
                child: Text(
                  candidate.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(CandidatesProvider provider) {
    final isVotoBlanco = candidate.name.toUpperCase().contains('VOTO EN BLANCO');
    if (isVotoBlanco) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('VOTO EN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black)),
          SizedBox(height: 12),
          Text('BLANCO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black)),
        ],
      );
    }

    Widget imageWidget;
    if (candidate.picture == null) {
      imageWidget = const Icon(Icons.person, size: 60, color: Colors.grey);
    } else {
      final resolved = provider.resolvePath(candidate.picture);
      if (resolved == null) {
        imageWidget = const Icon(Icons.person, size: 60, color: Colors.grey);
      } else if (resolved.startsWith('assets/')) {
        imageWidget = Image.asset(resolved, fit: BoxFit.cover);
      } else {
        imageWidget = Image.file(
          File(resolved), 
          fit: BoxFit.cover, 
          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60, color: Colors.grey)
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: imageWidget,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final Voter voter;
  final VoidCallback onVotesSubmitted;

  const _SubmitButton({required this.voter, required this.onVotesSubmitted});

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();
    final l10n = AppLocalizations.of(context)!;
    final isReady = votingProvider.isAllSelected();

    return FloatingActionButton.extended(
      onPressed: isReady && !votingProvider.isSaving
          ? () async {
              final success = await votingProvider.submitVotes(voter.id!);
              if (success) {
                onVotesSubmitted();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al guardar los votos.')),
                );
              }
            }
          : null,
      backgroundColor: isReady ? Colors.teal : Colors.grey,
      icon: votingProvider.isSaving 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Icon(Icons.send_rounded),
      label: const Text('VOTAR', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
