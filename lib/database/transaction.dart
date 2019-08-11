import 'package:Eyemoney/outsourcing/globals.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyTransaction {
  final int id;
  final String category;
  final String description;
  final double amount;
  final String date;

  MyTransaction(
      {this.id, this.category, this.description, this.amount, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }

  // Implement toString to make it easier to see information about
  // each Transaction when using the print statement.
  @override
  String toString() {
    return 'MyTransactions{id: $id, category: $category, description: $description, amount: $amount, date: $date}';
  }
}

Future<Database> getDataBase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), appName + 'Database.db'),
// When the database is first created, create a table to store transactions.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, description TEXT, amount REAL, date DATETIME)",
      );
    },
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
    version: 1,
  );
  return database;
}

Future<void> updateTransaction(MyTransaction transaction) async {
  // Get a reference to the database.
  final db = await getDataBase();

  // Update the given Dog.
  await db.update(
    'transactions',
    transaction.toMap(),
    // Ensure that the Dog has a matching id.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [transaction.id],
  );
}

Future<void> insertInDatabase(MyTransaction data) async {
  // Get a reference to the database.
  final Database db = await getDataBase();

  // Insert the Dog into the correct table. Also specify the
  // `conflictAlgorithm`. In this case, if the same dog is inserted
  // multiple times, it replaces the previous data.
  await db.insert(
    'transactions',
    data.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<MyTransaction>> getDatabase(DateTime selectedDate) async {
  final Database db = await getDataBase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('transactions',
      where: "date = ?",
      whereArgs: [
        (selectedDate ?? DateTime(DateTime.now().year, DateTime.now().month))
            .toString()
      ]);

  return List.generate(maps.length, (i) {
    return MyTransaction(
      id: maps[i]['id'],
      category: maps[i]['category'],
      description: maps[i]['description'],
      amount: maps[i]['amount'],
      date: maps[i]['date'],
    );
  });
}

Future<void> removeFromDatabase(MyTransaction data) async {
  // Get a reference to the database.
  final db = await getDataBase();

  // Remove the Transaction from the database.
  await db.delete(
    'transactions',
    // Use a `where` clause to delete a specific transaction.
    where: "id = ?",
    // Pass the Transactions's id as a whereArg to prevent SQL injection.
    whereArgs: [data.id],
  );
}
