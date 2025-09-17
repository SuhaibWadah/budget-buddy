import 'package:expense_tracker/data/models/category_model.dart';
import 'package:expense_tracker/providers/category_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Category> _categories = [];
  final TextEditingController _categoryController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    final cat = context.read<CategoryProvider>();
    cat.readCategories();
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    if (RegExp(r'[0-9]').hasMatch(value)) {
      setState(() {
        _errorText = 'Numbers not allowed';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _categories = context.watch<CategoryProvider>().categories;
    final catProvider = context.watch<CategoryProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          spacing: 15,
          children: [
            Row(
              spacing: 15,
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    autofocus: true,
                    onChanged: _validateInput,
                    decoration: InputDecoration(
                        labelText: 'Enter a Category',
                        errorText: _errorText,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        )),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_categoryController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Category is empty'),
                          backgroundColor: Colors.redAccent,
                        ));
                      } else {
                        final cat =
                            Category(name: _categoryController.text.trim());
                        try {
                          await catProvider.addCategory(cat);
                          _categoryController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Category added'),
                            backgroundColor: Colors.green[700],
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to add category'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: Text('Save'))
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 8),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return Dismissible(
                    key: ValueKey(category.id),
                    direction:
                        DismissDirection.endToStart, // swipe left to delete
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(Icons.delete_forever,
                          color: Colors.white, size: 28),
                    ),
                    onDismissed: (_) async {
                      await context
                          .read<CategoryProvider>()
                          .deleteCategory(category.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${category.name} deleted')),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.category),
                      title: Text(category.name),
                      tileColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onTap: () {
                        print('Tapped ${category.name}');
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
