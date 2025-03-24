import 'package:flutter/material.dart';
import 'expense_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ExpensePage()),
          ),
          child: Text('Go to Expense Tracker'),
        ),
      ),
    );
  }
}
