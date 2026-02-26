import '../../../domain/entities/grado.dart';
import '../../../domain/repositories/grado_repository.dart';

class GetGradosUseCase {
  final GradoRepository repository;

  GetGradosUseCase(this.repository);

  Future<List<Grado>> execute() {
    return repository.getAllGrados();
  }
}
