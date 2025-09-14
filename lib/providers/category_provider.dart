import 'package:expense_tracker/data/models/category_model.dart';
import 'package:expense_tracker/data/repositories/categories_repo.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final CategoriesRepo _catRepo;
  final CategoryService _catServie;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  CategoryProvider(this._authProvider, this._catRepo, this._catServie);

  Future<void> readCategories() async {
    final local = await _catRepo.readCategories();
    _categories = local
        .map((cat) => Category.fromMap(cat as Map<String, dynamic>))
        .toList();
  }
}
