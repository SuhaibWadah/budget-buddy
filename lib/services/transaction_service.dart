import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final user = FirebaseAuth.instance.currentUser;
  late final userDb = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid);
  final String _collection = 'transactions';

  Future<void> addTransaction(String? uid, TransactionModel tx) async {
    await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .doc(tx.id)
        .set(tx.toFirestore());
  }

  Future<void> updateTransaction(String? uid, TransactionModel tx) async {
    await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .doc(tx.id)
        .update(tx.toFirestore());
  }

  Future<void> deleteTransaction(String? uid, String id) async {
    await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .doc(id)
        .delete();
  }

  Future<List<TransactionModel>> readTransactions(String? uid) async {
    final query = await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .get();
    return query.docs
        .map((doc) => TransactionModel.fromMap({"id": doc.id, ...doc.data()}))
        .toList();
  }
}
