class Voter {
  final int? id;
  final String name;
  final String documentId;
  final int gradeId;
  final bool hasVoted;

  Voter({
    this.id,
    required this.name,
    required this.documentId,
    required this.gradeId,
    this.hasVoted = false,
  });
}
