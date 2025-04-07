// expense_list.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/db_helper.dart';

class ExpenseList extends StatelessWidget {
  final Future<List<Expense>> expenses;
  final Function(Expense) onExpenseSelected;

  const ExpenseList({super.key, required this.expenses, required this.onExpenseSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: expenses,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No expenses found.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final expense = snapshot.data![index];
            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
              child: ListTile(
                title: Text(expense.name),
                subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
                trailing: Text(expense.category),
                onTap: () => onExpenseSelected(expense),
              ),
            );
          },
        );
      },
    );
  }
}