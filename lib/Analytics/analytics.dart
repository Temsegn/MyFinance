// analytics.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../provider/transactionProvider.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedFilter = 'All'; // Default filter
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Compute spending per category based on the selected filter
  Map<String, double> _computeCategorySpending(
    List<Map<String, dynamic>> transactions,
  ) {
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
        startDate = _customStartDate ?? now.subtract(const Duration(days: 365));
        endDate = _customEndDate ?? now;
        break;
      case 'Income':
      case 'Expense':
        startDate = DateTime(2000);
        endDate = now;
        break;
      default: // 'All'
        startDate = DateTime(2000);
        endDate = now;
    }

    final filteredTransactions =
        transactions.where((t) {
          final date = DateTime.parse(t['date']);
          final inRange =
              date.isAfter(startDate) &&
              date.isBefore(endDate.add(const Duration(days: 1)));
          return _selectedFilter == 'All' ||
                  _selectedFilter == 'Week' ||
                  _selectedFilter == 'Month' ||
                  _selectedFilter == 'Year' ||
                  _selectedFilter == 'Custom'
              ? inRange
              : inRange && t['type'] == _selectedFilter;
        }).toList();

    final Map<String, double> spending = {};
    for (var t in filteredTransactions) {
      final category = t['category'] ?? 'Uncategorized';
      final amount = (t['amount'] as double).abs();
      spending[category] = (spending[category] ?? 0) + amount;
    }
    return spending;
  }

  // Filter transactions for the list
  List<Map<String, dynamic>> _filterTransactions(
    List<Map<String, dynamic>> transactions,
  ) {
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
        startDate = _customStartDate ?? now.subtract(const Duration(days: 365));
        endDate = _customEndDate ?? now;
        break;
      case 'Income':
      case 'Expense':
        startDate = DateTime(2000);
        endDate = now;
        break;
      default: // 'All'
        startDate = DateTime(2000);
        endDate = now;
    }

    return transactions.where((t) {
      final date = DateTime.parse(t['date']);
      final inRange =
          date.isAfter(startDate) &&
          date.isBefore(endDate.add(const Duration(days: 1)));
      return _selectedFilter == 'All' ||
              _selectedFilter == 'Week' ||
              _selectedFilter == 'Month' ||
              _selectedFilter == 'Year' ||
              _selectedFilter == 'Custom'
          ? inRange
          : inRange && t['type'] == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final categorySpending = _computeCategorySpending(
          provider.transactions,
        );
        final filteredTransactions = _filterTransactions(provider.transactions);

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
                    _buildFilterButton('Week'),
                    _buildFilterButton('Month'),
                    _buildFilterButton('Year'),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        final range = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange:
                              _customStartDate != null && _customEndDate != null
                                  ? DateTimeRange(
                                    start: _customStartDate!,
                                    end: _customEndDate!,
                                  )
                                  : null,
                        );
                        if (range != null) {
                          setState(() {
                            _customStartDate = range.start;
                            _customEndDate = range.end;
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
                      barGroups:
                          categorySpending.entries.map((e) {
                            final index = categorySpending.keys
                                .toList()
                                .indexOf(e.key);
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value,
                                  color: _getColorForCategory(e.key),
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
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
                              final category = categorySpending.keys.elementAt(
                                value.toInt(),
                              );
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
                            getTitlesWidget:
                                (value, meta) => Text(
                                  '\$${value.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey.withOpacity(0.8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final category = categorySpending.keys.elementAt(
                              group.x.toInt(),
                            );
                            return BarTooltipItem(
                              '\$${rod.toY.toStringAsFixed(2)}',
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterButton('All'),
                    Row(
                      children: [
                        _buildFilterButton('Income'),
                        const SizedBox(width: 16),
                        _buildFilterButton('Expense'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final t = filteredTransactions[index];
                      return _buildTransactionCard(
                        icon: _getIconForCategory(t['category']),
                        iconColor: _getColorForCategory(t['category']),
                        title: t['title'],
                        description:
                            t['description'] ??
                            '${t['type']} - ${t['category'] ?? 'Uncategorized'}',
                        amount: t['amount'],
                        date: t['date'],
                        onEdit:
                            () => provider.showTransactionDialog(
                              context,
                              index: provider.transactions.indexOf(t),
                            ),
                        onDelete:
                            () => provider.deleteTransaction(
                              provider.transactions.indexOf(t),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String filter) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Text(
        filter,
        style: TextStyle(
          fontSize: 16,
          color: _selectedFilter == filter ? Colors.black : Colors.grey,
          fontWeight:
              _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Color _getColorForCategory(String? category) {
    switch (category ?? 'Uncategorized') {
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

  IconData _getIconForCategory(String? category) {
    switch (category ?? 'Uncategorized') {
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

  Color _getColorForType(String? type) {
    switch (type ?? 'Uncategorized') {
      case 'Income':
        return Colors.green;
      case 'Expense':
        return Colors.red;
      default:
        return const Color.fromARGB(255, 241, 97, 97); // Neutral fallback color
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
  final Color amountColor = _getColorForType(amount >= 0 ? 'Income' : 'Expense');

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blue[900], // Blue-black color for title
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: amountColor, // Color based on type (green/red)
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 2), // Reduced spacing for tighter layout
          Text(
            date,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') onEdit();
          if (value == 'delete') onDelete();
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
          ),
          const PopupMenuItem(
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
  const TransactionManagementPage({super.key});

  @override
  TransactionManagementPageState createState() =>
      TransactionManagementPageState();
}

class TransactionManagementPageState extends State<TransactionManagementPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
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
                  child:
                      provider.transactions.isEmpty
                          ? const Center(
                            child: Text(
                              'No transactions yet. Add one to get started!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: provider.transactions.length,
                            itemBuilder: (context, index) {
                              final t = provider.transactions[index];
                              return _buildTransactionCard(
                                icon: _getIconForCategory(t['category']),
                                iconColor: _getColorForType(t['type']),
                                title: t['title'],
                                description:
                                    t['description'] ??
                                    '${t['type']} - ${t['category'] ?? 'Uncategorized'}',
                                amount: t['amount'],
                                date: t['date'],
                                onEdit:
                                    () => provider.showTransactionDialog(
                                      context,
                                      index: index,
                                    ),
                                onDelete:
                                    () => provider.deleteTransaction(index),
                              );
                            },
                          ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => provider.showTransactionDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
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
      },
    );
  }

  IconData _getIconForCategory(String? category) {
    switch (category ?? 'Uncategorized') {
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
  final Color amountColor = _getColorForType(amount >= 0 ? 'Income' : 'Expense');

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[900], // Blue-black color for title
                  ),
                ),
                const SizedBox(height: 2), // Spacing between title and description
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${amount.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: amountColor, // Green for Income, Red for Expense
                ),
              ),
              const SizedBox(height: 2), // Spacing between amount and date
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') onEdit();
          if (value == 'delete') onDelete();
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
          ),
          const PopupMenuItem(
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

// Helper method to determine color based on transaction type
Color _getColorForType(String? type) {
  switch (type ?? 'Uncategorized') {
    case 'Income':
      return Colors.green;
    case 'Expense':
      return Colors.red;
    default:
      return const Color.fromARGB(255, 241, 97, 97); // Neutral fallback color
  }
}

}
