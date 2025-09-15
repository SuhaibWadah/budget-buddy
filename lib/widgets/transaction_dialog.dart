import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/category_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionDialog extends StatefulWidget {
  TransactionDialog({super.key});

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  bool _isExpense = false;
  int? categoryId;
  bool isLoading = false;

  void clearFields() {
    _titleController.clear();
    _noteController.clear();
    _amountController.clear();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit(BuildContext context) async {
    final transProvider = context.read<TransactionProvider>();
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      return;
    }

    String formatted =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    final transaction = TransactionModel(
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: formatted,
      isExpense: _isExpense,
      categoryId: categoryId!,
    );
    setState(() {
      isLoading = true;
    });
    await transProvider.addTransaction(transaction);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transaction saved')));

    setState(() {
      isLoading = false;
    });
    clearFields();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    final catProvider = context.read<CategoryProvider>();
    catProvider.readCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<CategoryProvider>().categories;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _getFormField(title: 'Title', controller: _titleController),
            _getFormField(
              title: 'Note',
              canBeEmpty: true,
              controller: _noteController,
            ),
            _getFormField(
              title: 'Amount',
              keyboardType: TextInputType.number,
              controller: _amountController,
            ),
            Row(
              children: [
                Text(_selectedDate.toString().split(' ')[0]),
                IconButton(onPressed: _pickDate, icon: Icon(Icons.date_range)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _isExpense,
                  onChanged: (value) {
                    setState(() {
                      _isExpense = value!;
                    });
                  },
                ),
                Text('Is Expense'),
              ],
            ),
            DropdownButtonFormField<int>(
              hint: Text('Select a Category'),
              validator: (value) {
                if (value == null) {
                  return 'Please Select a Category';
                }
                return null;
              },
              initialValue: categoryId,
              items: categories.map((cat) {
                return DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  categoryId = value;
                });
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    isLoading ? null : _submit(context);
                  },
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text('Save'),
                ),
                ElevatedButton(
                    onPressed: () {
                      debugPrint("Categories: ${categories.length}");
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextFormField _getFormField({
  required String title,
  bool canBeEmpty = false,
  TextInputType keyboardType = TextInputType.text,
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: title),
    validator: (value) {
      if (!canBeEmpty) {
        if (value == null || value.trim().isEmpty) {
          return 'Please Enter a Valid $title';
        }
      } else {
        return null;
      }
    },
  );
}
