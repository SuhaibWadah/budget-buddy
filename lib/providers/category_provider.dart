import 'package:expense_tracker/data/models/category_model.dart';
import 'package:expense_tracker/data/repositories/categories_repo.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final CategoriesRepo _catRepo;
  final CategoryService _catServie;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  CategoryProvider(this._catRepo, this._catServie);

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<void> readCategories() async {
    final local = await _catRepo.readCategories();
    _categories = local
        .map((cat) => Category.fromMap(cat as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> addCategory(Category cat) async {
    final id = await _catRepo.insertCategory(cat.toMap());
    cat.id = id;
    categories.add(cat);
    notifyListeners();
    // Syncing with firebase if user is logged in
    if (_authProvider!.isLoggedIn) {
      await _catServie.addCategory(_authProvider!.user!.uid as int, cat);
      cat.isSynced = true;
      _catRepo.markCategoryAsSynced(cat.id);
    }
  }

  Future<void> deleteCategory(int id) async {
    _catRepo.deleteCategory(id);
    categories.removeWhere((cat) => cat.id == id);
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      await _catServie.deleteCategory(_authProvider!.user!.uid as int, id);
    }
  }
}
