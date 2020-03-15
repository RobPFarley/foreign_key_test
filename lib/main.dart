import 'package:flutter/material.dart';
import 'package:foreign_key_test/dao.dart';
import 'package:foreign_key_test/database.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: this.db,
      child: Provider<Dao>(
        create: (_) => Dao(this.db),
        child: MaterialApp(
          title: 'Flutter Database Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'TODOS'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final stream = Provider.of<Dao>(context).getAllTodos();

    return StreamBuilder<List<Todo>>(
      stream: stream,
      initialData: const [],
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(this.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => Provider.of<Dao>(context, listen: false).deleteTodos(),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var index = snapshot.data.length + 1;
                  var categoryID = await Provider.of<Dao>(context, listen: false).addCategory('Category $index');
                  Provider.of<Dao>(context, listen: false).addTodo('Todo $index', 'This is a todo', categoryID);
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(snapshot.data[index].title),
            ),
          ),
        );
      },
    );
  }
}
