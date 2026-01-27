class Voter {
  final int? id;
  final String name;
  final String documentId;
  final String? password;
  final int gradeId;
  final bool hasVoted;

  Voter({
    this.id,
    required this.name,
    required this.documentId,
    this.password,
    required this.gradeId,
    this.hasVoted = false,
  });
}
