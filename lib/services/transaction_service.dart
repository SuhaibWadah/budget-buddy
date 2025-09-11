import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'transactions';

  Future<void> addTransaction(TransactionModel tx) async {
    await _db.collection(_collection).doc(tx.id).set(tx.toMap(tx));
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await _db.collection(_collection).doc(tx.id).update(tx.toMap(tx));
  }

  Future<void> deleteTransaction(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<List<TransactionModel>> readTransactions() async {
    final query = await _db.collection(_collection).get();
    return query.docs
        .map((doc) => TransactionModel.fromMap({"id": doc.id, ...doc.data()}))
        .toList();
  }
}
