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

  Voter copyWith({
    int? id,
    String? name,
    String? documentId,
    String? password,
    int? gradeId,
    bool? hasVoted,
  }) {
    return Voter(
      id: id ?? this.id,
      name: name ?? this.name,
      documentId: documentId ?? this.documentId,
      password: password ?? this.password,
      gradeId: gradeId ?? this.gradeId,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}
