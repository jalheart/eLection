class Candidate {
  final int? id;
  final String name;
  final String? picture;
  final int categoryId;

  Candidate({
    this.id,
    required this.name,
    this.picture,
    required this.categoryId,
  });
}
