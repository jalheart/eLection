import '../../infrastructure/services/backup_service.dart';

class ImportDataUseCase {
  final BackupService backupService;

  ImportDataUseCase(this.backupService);

  Future<void> execute(String zipPath) async {
    await backupService.restoreBackup(zipPath);
  }
}
