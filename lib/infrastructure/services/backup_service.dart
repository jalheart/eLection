import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupService {
  Future<String> createBackup() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final electionDir = Directory(p.join(appDocDir.path, 'election'));

    if (!await electionDir.exists()) {
      throw Exception('Directorio de datos no encontrado.');
    }

    final encoder = ZipFileEncoder();
    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'backup_election_${DateTime.now().millisecondsSinceEpoch}.zip');
    
    encoder.create(zipPath);
    await encoder.addDirectory(electionDir);
    encoder.close();

    return zipPath;
  }

  Future<void> restoreBackup(String zipPath) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final electionDir = Directory(p.join(appDocDir.path, 'election'));

    // 1. Extract to a temporary location first
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // 2. Clear current election directory if it exists
    if (await electionDir.exists()) {
      await electionDir.delete(recursive: true);
    }
    await electionDir.create(recursive: true);

    // 3. Extract all files
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(p.join(appDocDir.path, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(p.join(appDocDir.path, filename)).createSync(recursive: true);
      }
    }
  }
}
