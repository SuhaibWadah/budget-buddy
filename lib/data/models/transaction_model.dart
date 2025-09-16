import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TransactionModel {
  String id;
  final String title;
  final String? note;
  final double amount;
  final DateTime date;
  final bool isExpense;
  bool isSynced;
  final int categoryId;

  TransactionModel({
    String? id,
    required this.title,
    this.note,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.isSynced = false,
    required this.categoryId,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note ?? '',
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'isExpense': isExpense ? 1 : 0,
      'isSynced': isSynced ? 1 : 0,
      'categoryId': categoryId,
    };
  }

  /// For Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'note': note ?? '',
      'amount': amount,
      'date': Timestamp.fromDate(date), // Firestore can store DateTime directly
      'isExpense': isExpense,
      'isSynced': isSynced,
      'categoryId': categoryId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    final rawDate = map['date'];

    DateTime parsedDate;

    if (rawDate is int) {
      // ✅ Already stored as timestamp
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      // ✅ Old string format (e.g., "2025-09-16")
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      // fallback
      parsedDate = DateTime.now();
    }
    print("${map['title']} ${map['categoryId']}");
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      amount: (map['amount'] as num).toDouble(),
      date: parsedDate,
      isExpense: (map['isExpense'] ?? 0) == 1,
      isSynced: (map['isSynced'] ?? 0) == 1,
      categoryId: (map['categoryId']) as int,
    );
  }

  /// For Firestore
  factory TransactionModel.fromFirestore(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      amount: (map['amount'] as num).toDouble(),
      date:
          (map['date'] as Timestamp).toDate(), // Firestore Timestamp → DateTime
      isExpense: map['isExpense'] as bool,
      isSynced: map['isSynced'] as bool,
      categoryId: map['categoryId'],
    );
  }
}
