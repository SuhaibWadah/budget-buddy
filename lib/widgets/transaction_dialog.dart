import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/category_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({super.key, this.transaction});
  final TransactionModel? transaction;

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  bool? _isExpense;
  int? _categoryId;
  bool isLoading = false;
  bool? isUpdate;

  @override
  void initState() {
    super.initState();
    final catProvider = context.read<CategoryProvider>();
    catProvider.readCategories();
    _titleController.text = widget.transaction?.title ?? '';
    _amountController.text = widget.transaction?.amount.toString() ?? '';
    _noteController.text = widget.transaction?.note ?? '';
    _selectedDate = widget.transaction?.date ?? DateTime.now();
    _isExpense = widget.transaction?.isExpense ?? false;
    if (mounted && widget.transaction?.categoryId != null) {
      _categoryId = widget.transaction?.categoryId;
    }
    isUpdate = widget.transaction != null;
  }

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

  void _submit(BuildContext context, bool? isUpdate) async {
    final transProvider = context.read<TransactionProvider>();
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      return;
    }

    // Make sure ID is correct
    final transaction = TransactionModel(
      id: isUpdate == true
          ? widget.transaction!.id // must exist for update
          : null, // new transaction → generate UUID
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate!,
      isExpense: _isExpense ?? true,
      categoryId: _categoryId!,
    );

    debugPrint(
        'Submitting transaction with id: ${transaction.id}, categoryId: ${transaction.categoryId}');

    setState(() => isLoading = true);

    if (isUpdate == true) {
      await transProvider.updateTransaction(transaction);
    } else {
      await transProvider.addTransaction(transaction);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            isUpdate == true ? 'Transaction Updated' : 'Transaction Saved')));

    setState(() => isLoading = false);
    clearFields();
    Navigator.of(context).pop();
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
    final categories = context.watch<CategoryProvider>().categories;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 5,
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
            DropdownButtonFormField<int?>(
              hint: Text('Select a Category'),
              validator: (value) {
                if (value == null) {
                  return 'Please Select a Category';
                }
                return null;
              },
              initialValue: _categoryId,
              items: categories.map((cat) {
                return DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _categoryId = value;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              spacing: 50,
              children: [
                ElevatedButton(
                  onPressed: () {
                    isLoading
                        ? null
                        : isUpdate!
                            ? _submit(context, isUpdate)
                            : _submit(context, isUpdate);
                  },
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : isUpdate!
                          ? Text('Update')
                          : Text('Save'),
                ),
                TextButton(
                    onPressed: () {
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
      return null;
    },
  );
}
