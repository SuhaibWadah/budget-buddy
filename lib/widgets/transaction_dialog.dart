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
  DateTime? _selectedDate;
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

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    final transProvider = context.read<TransactionProvider>();

    String formatted =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final transaction = TransactionModel(
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: formatted,
      isExpense: _isExpense,
      categoryId: categoryId!,
    );
    isLoading = true;
    transProvider.addTransaction(transaction);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transaction saved')));
    isLoading = false;
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
    final _categories = context.read<CategoryProvider>().categories;

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
                Text(_selectedDate.toString()),
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
              validator: (value) {
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a category')),
                  );
                  return;
                }
              },
              initialValue: categoryId,
              items: _categories.map((cat) {
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
            ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text('Save'),
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
