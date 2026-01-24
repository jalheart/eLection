import '../../../domain/entities/grado.dart';
import '../../../domain/repositories/grado_repository.dart';

class SaveGradoUseCase {
  final GradoRepository repository;

  SaveGradoUseCase(this.repository);

  Future<void> execute(Grado grado) {
    return repository.saveGrado(grado);
  }
}
