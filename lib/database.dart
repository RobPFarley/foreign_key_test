import 'dart:io';

import 'package:foreign_key_test/dao.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

part 'database.g.dart';

@UseMoor(
  daos: [
    Dao,
  ],
  include: {'database.moor'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(constructDb());
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  int get schemaVersion => 1;
}

QueryExecutor constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return executor;
  }
  if (Platform.isMacOS || Platform.isLinux) {
    final file = File('db.sqlite');
    return VmDatabase(file, logStatements: logStatements);
  }
  return VmDatabase.memory(logStatements: logStatements);
}