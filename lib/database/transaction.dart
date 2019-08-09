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
