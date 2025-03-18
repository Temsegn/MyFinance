import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fl_chart/fl_chart.dart'; // Using 0.54.0 to avoid MediaQuery.boldTextOverride

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedFilter = 'All'; // Default filter
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Sample transaction data
  final List<Map<String, dynamic>> _sampleTransactions = [
    {
      'title': 'Shoes',
      'description': 'Nike Sneakers',
      'amount': -540.00,
      'category': 'Shopping',
      'date': DateTime(2024, 8, 26),
      'icon': Icons.shopping_bag,
      'iconColor': Colors.orange,
    },
    {
      'title': 'Tshirt',
      'description': '2 pcs',
      'amount': -515.00,
      'category': 'Shopping',
      'date': DateTime(2024, 8, 23),
      'icon': Icons.local_mall,
      'iconColor': Colors.pink,
    },
    {
      'title': 'Pants',
      'description': '2 pcs',
      'amount': -510.00,
      'category': 'Shopping',
      'date': DateTime(2024, 8, 23),
      'icon': Icons.local_laundry_service,
      'iconColor': Colors.yellow,
    },
    {
      'title': 'Groceries',
      'description': 'Weekly shopping',
      'amount': -150.00,
      'category': 'Food',
      'date': DateTime(2024, 8, 20),
      'icon': Icons.local_dining,
      'iconColor': Colors.green,
    },
    {
      'title': 'Bus Fare',
      'description': 'Daily commute',
      'amount': -200.00,
      'category': 'Transport',
      'date': DateTime(2024, 7, 15),
      'icon': Icons.directions_car,
      'iconColor': Colors.blue,
    },
  ];

  // Compute spending per category based on the selected filter
  Map<String, double> _computeCategorySpending() {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (_selectedFilter) {
      case 'Week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      case 'Custom':
        if (_customStartDate == null || _customEndDate == null) {
          startDate = now.subtract(const Duration(days: 365)); // Fallback to 1 year
          endDate = now;
        } else {
          startDate = _customStartDate!;
          endDate = _customEndDate!;
        }
        break;
      case 'Food':
      case 'Shopping':
      case 'Transport':
        startDate = DateTime(2000); // Show all for category filters
        endDate = now;
        break;
      default: // 'All'
        startDate = DateTime(2000); // Show all
        endDate = now;
    }

    // Filter transactions based on date range and category
    final filteredTransactions = _sampleTransactions.where((transaction) {
      final transactionDate = transaction['date'] as DateTime;
      final withinDateRange = transactionDate.isAfter(startDate) && transactionDate.isBefore(endDate.add(const Duration(days: 1)));
      if (_selectedFilter == 'Food' || _selectedFilter == 'Shopping' || _selectedFilter == 'Transport') {
        return withinDateRange && transaction['category'] == _selectedFilter;
      }
      return withinDateRange;
    }).toList();

    // Compute spending per category
    final Map<String, double> categorySpending = {};
    for (var transaction in filteredTransactions) {
      final category = transaction['category'] as String;
      final amount = (transaction['amount'] as double).abs();
      categorySpending[category] = (categorySpending[category] ?? 0) + amount;
    }

    return categorySpending;
  }

  // Filter transactions for the list based on the selected filter
  List<Map<String, dynamic>> _filterTransactions() {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (_selectedFilter) {
      case 'Week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      case 'Custom':
        if (_customStartDate == null || _customEndDate == null) {
          startDate = now.subtract(const Duration(days: 365));
          endDate = now;
        } else {
          startDate = _customStartDate!;
          endDate = _customEndDate!;
        }
        break;
      case 'Food':
      case 'Shopping':
      case 'Transport':
        startDate = DateTime(2000);
        endDate = now;
        break;
      default: // 'All'
        startDate = DateTime(2000);
        endDate = now;
    }

    return _sampleTransactions.where((transaction) {
      final transactionDate = transaction['date'] as DateTime;
      final withinDateRange = transactionDate.isAfter(startDate) && transactionDate.isBefore(endDate.add(const Duration(days: 1)));
      if (_selectedFilter == 'Food' || _selectedFilter == 'Shopping' || _selectedFilter == 'Transport') {
        return withinDateRange && transaction['category'] == _selectedFilter;
      }
      return withinDateRange;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categorySpending = _computeCategorySpending();
    final filteredTransactions = _filterTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
        backgroundColor: Colors.white,
        elevation: 0,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Week';
                    });
                  },
                  child: Text(
                    'Week',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedFilter == 'Week' ? Colors.black : Colors.grey,
                      fontWeight: _selectedFilter == 'Week' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Month';
                    });
                  },
                  child: Text(
                    'Month',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedFilter == 'Month' ? Colors.black : Colors.grey,
                      fontWeight: _selectedFilter == 'Month' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Year';
                    });
                  },
                  child: Text(
                    'Year',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedFilter == 'Year' ? Colors.black : Colors.grey,
                      fontWeight: _selectedFilter == 'Year' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                  onPressed: () async {
                    final pickedRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: _customStartDate != null && _customEndDate != null
                          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
                          : null,
                    );
                    if (pickedRange != null) {
                      setState(() {
                        _customStartDate = pickedRange.start;
                        _customEndDate = pickedRange.end;
                        _selectedFilter = 'Custom';
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: categorySpending.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value.key;
                    final amount = entry.value.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: amount,
                          color: _getColorForCategory(category),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final category = categorySpending.keys.elementAt(value.toInt());
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(
                              category,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData:   FlGridData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final category = categorySpending.keys.elementAt(group.x.toInt());
                        return BarTooltipItem(
                          '\$${(rod.toY).toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
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
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'All';
                    });
                  },
                  child: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedFilter == 'All' ? Colors.black : Colors.grey,
                      fontWeight: _selectedFilter == 'All' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Food';
                        });
                      },
                      child: Text(
                        'Food',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedFilter == 'Food' ? Colors.black : Colors.grey,
                          fontWeight: _selectedFilter == 'Food' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Shopping';
                        });
                      },
                      child: Text(
                        'Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedFilter == 'Shopping' ? Colors.black : Colors.grey,
                          fontWeight: _selectedFilter == 'Shopping' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Transport';
                        });
                      },
                      child: Text(
                        'Transport',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedFilter == 'Transport' ? Colors.black : Colors.grey,
                          fontWeight: _selectedFilter == 'Transport' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  return _buildTransactionCard(
                    icon: transaction['icon'] as IconData,
                    iconColor: transaction['iconColor'] as Color,
                    title: transaction['title'] as String,
                    description: transaction['description'] as String,
                    amount: transaction['amount'] as double,
                    date: transaction['date'].toString().split(' ')[0], // Format date
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
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