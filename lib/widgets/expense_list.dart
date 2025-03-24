// expense_list.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/db_helper.dart';

class ExpenseList extends StatelessWidget {
  final Future<List<Expense>> expenses = DatabaseHelper().getExpenses();

  ExpenseList({super.key, required Future<List<Expense>> expenses});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: expenses,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index].name),
              subtitle: Text('\$${snapshot.data![index].amount}'),
            );
          },
        );
      },
    );
  }
}
