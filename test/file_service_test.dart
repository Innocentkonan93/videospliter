import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_spliter/app/services/file_service.dart';

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  MockPathProviderPlatform(this.tempPath);

  @override
  Future<String?> getTemporaryPath() async {
    return tempPath;
  }
}

void main() {
  late Directory testTempDir;

  setUp(() {
    testTempDir = Directory.systemTemp.createTempSync('file_service_test');
    PathProviderPlatform.instance = MockPathProviderPlatform(testTempDir.path);
  });

  tearDown(() {
    if (testTempDir.existsSync()) {
      testTempDir.deleteSync(recursive: true);
    }
  });

  test('cleanTemporaryFiles deletes files older than 24 hours and keeps recent ones', () async {
    // 1. Create a recent file (modified now)
    final recentFile = File('${testTempDir.path}/recent.txt');
    recentFile.createSync();
    recentFile.writeAsStringSync('recent file content');

    // 2. Create an old file (modified 25 hours ago)
    final oldFile = File('${testTempDir.path}/old.txt');
    oldFile.createSync();
    oldFile.writeAsStringSync('old file content');
    oldFile.setLastModifiedSync(DateTime.now().subtract(const Duration(hours: 25)));

    // 3. Create another old file inside a sub-directory (modified 30 hours ago)
    final subDir = Directory('${testTempDir.path}/subdir')..createSync();
    final nestedOldFile = File('${subDir.path}/nested_old.txt');
    nestedOldFile.createSync();
    nestedOldFile.writeAsStringSync('nested old file content');
    nestedOldFile.setLastModifiedSync(DateTime.now().subtract(const Duration(hours: 30)));

    // 4. Run the cleanup
    await FileService.cleanTemporaryFiles();

    // 5. Verify the files
    expect(recentFile.existsSync(), isTrue, reason: 'Recent file should not be deleted');
    expect(oldFile.existsSync(), isFalse, reason: 'Old file should be deleted');
    expect(nestedOldFile.existsSync(), isFalse, reason: 'Nested old file should be deleted');
  });
}
