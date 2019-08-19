import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyTransaction {
  final int id;
  final String category;
  final String description;
  final int sign;
  final double amount;
  final int quantity;
  final String date;

  MyTransaction({this.id, this.category, this.description, this.sign, this.amount, this.quantity, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'sign': sign,
      'amount': amount,
      'quantity': quantity,
      'date': date,
    };
  }

  // Implement toString to make it easier to see information about
  // each Transaction when using the print statement.
  @override
  String toString() {
    return 'MyTransactions{id: $id, category: $category, description: $description, sign: $sign, amount: $amount, quantity: $quantity, date: $date}';
  }
}

Future<Database> getDataBase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'EyemoneyDatabase.db'),
// When the database is first created, create a table to store transactions.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE transactions("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "category TEXT, "
        "description TEXT, "
        "sign INTEGER, "
        "amount REAL DEFAULT 0 CHECK(amount >= 0), "
        "quantity INTEGER DEFAULT 1 CHECK(quantity > 0), "
        "date DATETIME)",
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
  final List<Map<String, dynamic>> maps =
      await db.query('transactions', where: "strftime('%m', date) = ?", whereArgs: [normMonthDatabase(((selectedDate ?? DateTime.now()).month).toString())]);

  return List.generate(maps.length, (i) {
    return MyTransaction(
      id: maps[i]['id'],
      category: maps[i]['category'],
      description: maps[i]['description'],
      sign: maps[i]['sign'],
      amount: maps[i]['amount'],
      quantity: maps[i]['quantity'],
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

String normMonthDatabase(String month) {
  return month.length == 1 ? ('0' + month) : month;
}
