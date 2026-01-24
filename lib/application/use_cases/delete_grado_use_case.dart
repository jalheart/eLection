import '../../../domain/repositories/grado_repository.dart';

class DeleteGradoUseCase {
  final GradoRepository repository;

  DeleteGradoUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deleteGrado(id);
  }
}
