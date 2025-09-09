class Transaction {
  final String id;
  final String title;
  final String? note;
  final String category;
  final double amount;
  final DateTime date;
  final bool isSynced;

  Transaction({
    required this.id,
    required this.title,
    this.note,
    required this.category,
    required this.amount,
    required this.date,
    this.isSynced = false,
  });

  Map<String, dynamic> toFirebase(Transaction trans) {
    return {
      'id': trans.id,
      'title': trans.title,
      'note': trans.note,
      'category': trans.category,
      'amount': trans.amount,
      'date': trans.date,
      'isSynced': trans.isSynced ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
