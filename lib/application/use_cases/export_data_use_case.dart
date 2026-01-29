import '../../infrastructure/services/backup_service.dart';

class ExportDataUseCase {
  final BackupService backupService;

  ExportDataUseCase(this.backupService);

  Future<String> execute() async {
    return await backupService.createBackup();
  }
}
