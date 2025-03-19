import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:provider/provider.dart'; 
import 'provider/transactionProvider.dart';
import 'provider/category_provider.dart';
void main() {
  runApp(
   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ], 
      child: const MaterialApp(
        debugShowCheckedModeBanner: false, 
        home: MainPage(),
      ),
    ),
  );
}