import 'dart:io';
import 'package:package_config/package_config.dart';

enum NahpuDataSet { mergeTestA, mergeTestB }

enum NahpuDataType { db, project, site }

Future<File> _getDataFile(NahpuDataSet dataSet, NahpuDataType type) async {
  final config = await findPackageConfig(Directory.current);
  if (config == null) {
    throw StateError('Could not locate .dart_tool/package_config.json');
  }

  final package = config['nahpu_data'];
  if (package == null) {
    throw StateError('Package nahpu_data not found in package config.');
  }

  final fileSuffix = (type == NahpuDataType.db ? '.sqlite3' : '.json');

  final fileUri = package.packageUriRoot.resolve(
    'src/data/${dataSet.name}/${type.name}$fileSuffix',
  );
  final file = File.fromUri(fileUri);
  if (!file.existsSync()) {
    throw FileSystemException(
      'Test data file does not exist at resolved path: ${file.path}',
    );
  }

  return file;
}

Future<String> getProjects(NahpuDataSet dataSet) async {
  final file = await _getDataFile(dataSet, NahpuDataType.project);
  return file.readAsString();
}

Future<String> getSites(NahpuDataSet dataSet) async {
  final file = await _getDataFile(dataSet, NahpuDataType.site);
  return file.readAsString();
}

Future<String> getDatabasePath(NahpuDataSet dataSet) async {
  final file = await _getDataFile(dataSet, NahpuDataType.db);
  return file.path;
}
