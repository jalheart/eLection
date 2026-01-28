class Vote {
  final int? id;
  final int voterId;
  final int candidateId;

  Vote({
    this.id,
    required this.voterId,
    required this.candidateId,
  });
}
