// lib/pages/expense_page.dart
import 'package:flutter/material.dart';
import '../widgets/expense_list.dart';
import '../database/db_helper.dart';
import '../models/expense.dart';
import '../widgets/expense_detail.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late Future<List<Expense>> _expenses;
  Expense? _selectedExpense;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() {
      _expenses = DatabaseHelper.instance.getExpenses();
      _selectedExpense = null;
    });
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const Text('Click on the "Add" button to add an expense. Tap on an expense to edit or delete it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _clearAllExpenses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Expenses'),
        content: const Text('Are you sure you want to delete all expenses? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteAllExpenses();
              _loadExpenses(); // Refresh the list
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All expenses deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/expense');
    }
  }

  void _onExpenseSelected(Expense expense) {
    setState(() {
      _selectedExpense = expense;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetail(
          expense: expense,
          onExpenseUpdated: _loadExpenses,
        ),
      ),
    ).then((_) {
      setState(() {
        _selectedExpense = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showInstructions,
            tooltip: 'Instructions',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/add-expense');
              _loadExpenses();
            },
            tooltip: 'Add Expense',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAllExpenses,
            tooltip: 'Clear All Expenses',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Expenses',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: isLargeScreen
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ExpenseList(
                      expenses: _expenses,
                      onExpenseSelected: _onExpenseSelected,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _selectedExpense != null
                        ? ExpenseDetail(
                      expense: _selectedExpense!,
                      onExpenseUpdated: _loadExpenses,
                    )
                        : const Center(child: Text('Select an expense to edit')),
                  ),
                ],
              )
                  : ExpenseList(
                expenses: _expenses,
                onExpenseSelected: _onExpenseSelected,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Expenses'),
        ],
        onTap: _onNavTap,
      ),
    );
  }
}