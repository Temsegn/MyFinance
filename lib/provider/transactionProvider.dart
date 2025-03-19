// transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_provider.dart';

class TransactionProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> get transactions => _transactions;

  void showTransactionDialog(BuildContext context, {int? index}) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          transactions: _transactions,
          index: index,
          onSave: () {
            notifyListeners(); // Notify listeners after saving the transaction
          },
        );
      },
    );
  }

  void deleteTransaction(int index) {
    if (index >= 0 && index < _transactions.length) {
      _transactions.removeAt(index);
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getTransactions() => _transactions;
}

// New StatefulWidget for the dialog
class TransactionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final int? index;
  final VoidCallback onSave;

  const TransactionDialog({
    Key? key,
    required this.transactions,
    this.index,
    required this.onSave,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  String? _type = 'Expense';
  String? _category;
  DateTime? _date;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _date = DateTime.now();
    _editingIndex = widget.index;

    if (_editingIndex != null) {
      final transaction = widget.transactions[_editingIndex!];
      _titleController.text = transaction['title'];
      _amountController.text = transaction['amount'].abs().toString();
      _type = transaction['type'];
      _category = transaction['category'];
      _date = DateTime.parse(transaction['date']);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = {
        'title': _titleController.text,
        'amount': _type == 'Income'
            ? double.parse(_amountController.text)
            : -double.parse(_amountController.text),
        'type': _type,
        'category': _category,
        'date': _date!.toIso8601String().split('T')[0],
      };

      if (_editingIndex != null) {
        widget.transactions[_editingIndex!] = transaction;
      } else {
        widget.transactions.add(transaction);
      }
      widget.onSave(); // Notify listeners after saving
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final List<String> categories = categoryProvider.categories;

    return AlertDialog(
      title: Text(_editingIndex == null ? 'Add Transaction' : 'Edit Transaction'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter an amount';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Income', 'Expense']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _type = value),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                decoration: const InputDecoration(labelText: 'Category'),
                hint: const Text('Select a category'),
              ),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Date'),
                child: Row(
                  children: [
                    Text(_date!.toIso8601String().split('T')[0]),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveTransaction,
          child: Text(_editingIndex == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}