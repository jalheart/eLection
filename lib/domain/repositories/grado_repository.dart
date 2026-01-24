import '../entities/grado.dart';

abstract class GradoRepository {
  Future<List<Grado>> getAllGrados();
  Future<Grado?> getGradoById(int id);
  Future<void> saveGrado(Grado grado);
  Future<void> deleteGrado(int id);
}
