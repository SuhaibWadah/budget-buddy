import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'categories';

  Future<void> addCategory(int id, String name) async {
    await _db.collection(_collection).doc(id.toString()).set({"name": name});
  }

  Future<void> deleteCategory(int id) async {
    await _db.collection(_collection).doc(id.toString()).delete();
  }

  Future<List<TransactionModel>> getCategories() async {
    final query = await _db.collection(_collection).get();
    return query.docs
        .map((doc) => TransactionModel.fromMap({"id": doc.id, ...doc.data()}))
        .toList();
  }
}
