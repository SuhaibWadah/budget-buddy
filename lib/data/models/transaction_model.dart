import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class TransactionModel {
  String id;
  final String title;
  final String? note;
  final double amount;
  final String date;
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
      'note': note,
      'amount': amount,
      'date': date,
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
      'note': note,
      'amount': amount,
      'date': date, // Firestore can store DateTime directly
      'isExpense': isExpense,
      'isSynced': isSynced,
      'categoryId': categoryId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      amount: map['amount'],
      date: map['date'], // store date as ISO string in SQLite
      isExpense: map['isExpense'] == 1,
      isSynced: map['isSynced'] == 1,
      categoryId: map['categoryId'],
    );
  }

  /// For Firestore
  factory TransactionModel.fromFirestore(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      amount: (map['amount'] as num).toDouble(),
      date: map['date'], // Firestore Timestamp → DateTime
      isExpense: map['isExpense'] as bool,
      isSynced: map['isSynced'] as bool,
      categoryId: map['categoryId'],
    );
  }
}
