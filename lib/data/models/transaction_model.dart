class Transaction {
  final String id;
  final String title;
  final String? note;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final bool isSynced;
  final int categoryId;

  Transaction({
    required this.id,
    required this.title,
    this.note,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.isSynced = false,
    required this.categoryId,
  });

  Map<String, dynamic> toFirebase(Transaction trans) {
    return {
      'id': trans.id,
      'title': trans.title,
      'note': trans.note,
      'amount': trans.amount,
      'date': trans.date,
      'isExpense': trans.isExpense ? 1 : 0,
      'isSynced': trans.isSynced ? 1 : 0,
      'categoryId': trans.categoryId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      amount: map['amount'],
      date: map['date'],
      isExpense: map['isExpense'] == 1,
      isSynced: map['isSynced'] == 1,
      categoryId: map['categoryId'],
    );
  }
}
