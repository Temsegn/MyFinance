import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import 'package:myfinance/provider/transactionProvider.dart'; // Assuming you have TransactionProvider

// Define the Transaction class to match the structure in TransactionProvider
class Transaction {
  final String title;
  final String description;
  final String date;
  final double amount;
  final String type;
  final String? category;

  Transaction({
    required this.title,
    required this.description,
    required this.date,
    required this.amount,
    required this.type,
    this.category,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      title: map['title']?.toString() ?? 'Untitled',
      description: map['description']?.toString() ?? 'No description',
      date: map['date']?.toString() ?? 'No date',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type']?.toString() ?? 'Expense',
      category: map['category']?.toString(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  final ValueChanged<bool>? onHasNotificationsChanged; // Callback to notify parent of notification state

  const NotificationsPage({super.key, this.onHasNotificationsChanged});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Initialize the notification settings
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Your app icon

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a notification for a transaction
  Future<void> _showPaymentReminderNotification(Transaction transaction) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'payment_channel_id',
      'Payment Reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Payment Reminder',
      'You have a payment: ${transaction.title}',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final rawTransactions = transactionProvider.transactions;

    // Convert raw transactions to Transaction objects if necessary
    final List transactions = rawTransactions.map((item) {
      if (item is Transaction) {
        return item;
      } else if (item is Map<String, dynamic>) {
        return Transaction.fromMap(item);
      } else {
        // Fallback in case the item is neither a Transaction nor a Map
        return Transaction(
          title: 'Unknown',
          description: 'Unknown',
          date: '1970-01-01',
          amount: 0.0,
          type: 'Expense',
        );
      }
    }).toList();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayTransactions = transactions
        .where((transaction) => transaction.date == today)
        .toList();

    // Notify parent widget of notification state
    if (widget.onHasNotificationsChanged != null) {
      widget.onHasNotificationsChanged!(todayTransactions.isNotEmpty);
    }

    if (todayTransactions.isNotEmpty) {
      // Trigger notification for each transaction
      for (var transaction in todayTransactions) {
        _showPaymentReminderNotification(transaction);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: todayTransactions.isEmpty
          ? const EmptyNotificationsScreen()
          : ListView.builder(
              itemCount: todayTransactions.length,
              itemBuilder: (context, index) {
                final transaction = todayTransactions[index];
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(transaction.title),
                  subtitle: Text(transaction.description),
                  trailing: Text(transaction.date),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped: ${transaction.title}')),
                    );
                  },
                );
              },
            ),
    );
  }
}

class EmptyNotificationsScreen extends StatelessWidget {
  const EmptyNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.notifications_off, // Empty notifications icon
                size: 100,
                color: Colors.grey[400],
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "No Payment Reminders",
                description:
                    "You have no payments scheduled for today. We'll notify you when there are payments due.",
                btnText: "Check Again",
                press: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checking for updates...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16 * 2.5),
            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(btnText ?? "Retry".toUpperCase()),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}