import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final Map<String, List<Map<String, dynamic>>> transactionsByDate = {
    "Today": [
      {
        "name": "Shoes",
        "desc": "Nike Sneakers",
        "amount": -40.00,
        "icon": Icons.shopping_bag,
        "color": Colors.orange,
        "date": "Aug 26",
      },
      {
        "name": "Transport",
        "desc": "Uber Ride",
        "amount": -20.00,
        "icon": Icons.directions_car,
        "color": Colors.blue,
        "date": "Aug 26",
      },
    ],
    "Yesterday": [
      {
        "name": "Payment",
        "desc": "Transfer from Audrey",
        "amount": 190.00,
        "icon": Icons.attach_money,
        "color": Colors.green,
        "date": "Aug 24",
      },
       {
        "name": "Food",
        "desc": "Transfer from Audrey",
        "amount": 190.00,
        "icon": Icons.attach_money,
        "color": Colors.green,
        "date": "Aug 24",
      },
       {
        "name": "Clothes",
        "desc": "Transfer from Audrey",
        "amount": 190.00,
        "icon": Icons.attach_money,
        "color": Colors.green,
        "date": "Aug 24",
      },
    ],
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // AppBar & Body are now the same color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
            const SizedBox(width: 10),
            const Text(
              "Hey, Jacob!",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 73, 176, 205)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "\$4,586.00",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.blue),
            ),
            const SizedBox(height: 5),
            const Text(
              "Total Balance",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceCard(
                  "Income",
                  2450.00,
                 Icons.move_up,
                  const Color.fromARGB(255, 6, 210, 111),
                ),
                _buildBalanceCard(
                  "Expense",
                  710.00,
                  Icons.move_down,
                  Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 82, 80, 80)),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 5),
                children:
                    transactionsByDate.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ...entry.value.map(
                            (transaction) => _buildTransactionCard(
                              transaction["name"],
                              transaction["desc"],
                              transaction["amount"],
                              transaction["icon"],
                              transaction["color"],
                              transaction["date"],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),

      // Custom Bottom Navigation Bar with Floating Add Button
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.analytics, "Analytics", 1),
                const SizedBox(width: 60), // Space for Floating Add Button
                _buildNavItem(Icons.category, "Categories", 3),
                _buildNavItem(Icons.person, "Accounts", 4),
              ],
            ),
          ),

          // Floating Action Button directly inside Stack without SafeArea or Padding
          Positioned(
            bottom:
                20, // Adjusted the bottom margin slightly to fit the screen properly
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.blue : Colors.grey,
            size: 28,
          ),
          if (_selectedIndex == index)
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 7,),
                Text(
                  "-\$${amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    String title,
    String desc,
    double amount,
    IconData icon,
    Color iconColor,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amount >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
