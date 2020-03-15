import 'package:foreign_key_test/database.dart';
import 'package:moor/moor.dart';

part 'dao.g.dart';

@UseDao(tables: [
  Todos,
  Categories
])
class Dao extends DatabaseAccessor<AppDatabase> with _$DaoMixin {
  Dao(AppDatabase db) : super(db);

  Stream<List<Todo>> getAllTodos() {
    return select(db.todos).watch();
  }
  
  Future addTodo(String title, String body, int category) {
    return db.addTodo(title, body, category);
  }

  Future addCategory(String description) {
    return db.addCategory(description);
  }

  Future deleteTodos() {
    return db.deleteTodos();
  }
}