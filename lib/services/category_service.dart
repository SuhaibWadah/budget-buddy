import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/data/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final user = FirebaseAuth.instance.currentUser;
  late final userDb = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid);
  final String _collection = 'categories';

  Future<void> addCategory(int? uid, Category category) async {
    await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .doc(category.id.toString())
        .set({"name": category.name, "isSynced": 1});
  }

  Future<void> deleteCategory(int uid, int id) async {
    await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .doc(id.toString())
        .delete();
  }

  Future<List<Category>> getCategories(int? uid) async {
    final query = await userDb
        .collection('users')
        .doc(uid.toString())
        .collection(_collection)
        .get();
    return query.docs
        .map((doc) => Category.fromMap({"id": doc.id, ...doc.data()}))
        .toList();
  }
}
