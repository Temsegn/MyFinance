import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this dependency for charts
 
 

class AnalyticsPage extends StatelessWidget {
  final Map<String, double> categorySpending = {
    'Food': 150.0,
    'Shopping': 540.0,
    'Transport': 200.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Day',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Row(
                  children: const [
                    Text(
                      'Week',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Month',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData:   FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('Jun', style: style);
                              break;
                            case 1:
                              text = const Text('Jul', style: style);
                              break;
                            case 2:
                              text = const Text('Aug', style: style);
                              break;
                            case 3:
                              text = const Text('Sept', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: text,
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 100),
                        const FlSpot(1, 130),
                        const FlSpot(2, 170),
                        const FlSpot(3, 140),
                      ],
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 2,
                      dotData:   FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.2)),
                    ),
                  ],
                  minX: 0,
                  maxX: 3,
                  minY: 0,
                  maxY: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('All', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Row(
                  children: [
                    Text('Food', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(width: 16),
                    Text('Shopping', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(width: 16),
                    Text('Transport', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildTransactionCard(
                    icon: Icons.shopping_bag,
                    iconColor: Colors.orange,
                    title: 'Shoes',
                    description: 'Nike Sneakers',
                    amount: -540.00,
                    date: 'Aug 26',
                  ),
                  _buildTransactionCard(
                    icon: Icons.local_mall,
                    iconColor: Colors.pink,
                    title: 'Tshirt',
                    description: '2 pcs',
                    amount: -515.00,
                    date: 'Aug 23',
                  ),
                  _buildTransactionCard(
                    icon: Icons.local_laundry_service,
                    iconColor: Colors.yellow,
                    title: 'Pants',
                    description: '2 pcs',
                    amount: -510.00,
                    date: 'Aug 23',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required double amount,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Implement edit logic here
            } else if (value == 'delete') {
              // Implement delete logic here
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
        onTap: () {
          // Handle tap if needed
        },
      ),
    );
  }
}

class TransactionManagementPage extends StatefulWidget {
  final List<String> categories;

  const TransactionManagementPage({super.key, required this.categories});

  @override
  _TransactionManagementPageState createState() => _TransactionManagementPageState();
}

class _TransactionManagementPageState extends State<TransactionManagementPage> {
  final List<Map<String, dynamic>> _transactions = [];
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _type = 'Expense';
  String? _category;
  DateTime? _date = DateTime.now();
  int? _editingIndex;

  // Add or update a transaction
  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final amount = double.parse(_amountController.text);
      final transaction = {
        'title': title,
        'amount': _type == 'Income' ? amount : -amount,
        'type': _type,
        'category': _category,
        'date': _date!.toIso8601String().split('T')[0],
      };

      setState(() {
        if (_editingIndex != null) {
          _transactions[_editingIndex!] = transaction;
          _editingIndex = null;
        } else {
          _transactions.add(transaction);
        }
        _resetForm();
      });
      Navigator.of(context).pop();
    }
  }

  // Edit a transaction
  void _editTransaction(int index) {
    final transaction = _transactions[index];
    _titleController.text = transaction['title'];
    _amountController.text = transaction['amount'].abs().toString();
    _type = transaction['type'];
    _category = transaction['category'];
    _date = DateTime.parse(transaction['date']);
    _editingIndex = index;
    _showTransactionDialog(context);
  }

  // Delete a transaction
  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  // Reset form fields
  void _resetForm() {
    _titleController.clear();
    _amountController.clear();
    _type = 'Expense';
    _category = null;
    _date = DateTime.now();
    _editingIndex = null;
  }

  // Show dialog for adding or editing a transaction
  void _showTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
                    items: widget.categories
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
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Management'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Transactions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions yet. Add one to get started!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        return _buildTransactionCard(
                          icon: _getIconForCategory(transaction['category']),
                          iconColor: _getColorForCategory(transaction['category']),
                          title: transaction['title'],
                          description: '${transaction['type']} - ${transaction['category']}',
                          amount: transaction['amount'],
                          date: transaction['date'],
                          onEdit: () => _editTransaction(index),
                          onDelete: () => _deleteTransaction(index),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _showTransactionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add New Transaction',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String? category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Food':
        return Icons.local_dining;
      case 'Transport':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  Color _getColorForCategory(String? category) {
    switch (category) {
      case 'Shopping':
        return Colors.orange;
      case 'Food':
        return Colors.green;
      case 'Transport':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required double amount,
    required String date,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
 