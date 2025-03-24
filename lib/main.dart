import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/expense_page.dart';
import 'pages/add_expense.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/expense': (context) => const ExpensePage(),
        '/add-expense': (context) => AddExpensePage(),
      },
    );
  }
}