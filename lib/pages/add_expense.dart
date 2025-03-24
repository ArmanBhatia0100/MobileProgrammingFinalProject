import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/expense.dart';

class AddExpensePage extends StatefulWidget {
  AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  String _selectedPaymentMethod = 'Cash';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Entertainment', 'Health', 'Other'];
  final List<String> _paymentMethods = ['Cash', 'Credit', 'Debit'];

  void _addExpense() async {
    if (_formKey.currentState!.validate()) {
      Expense newExpense = Expense(
        name: _nameController.text,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        date: _selectedDate.toString(),
        paymentMethod: _selectedPaymentMethod,
      );
      await DatabaseHelper.instance.insertExpense(newExpense);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );
      _nameController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
      });
      Navigator.pop(context, true);
    }
  }

  Future<bool> _onWillPop() async {
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to discard this expense?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return result ?? false; // If the result is null, return false
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Expense')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Expense Name'),
                  validator: (value) => value!.isEmpty ? 'Enter expense name' : null,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter amount' : null,
                ),
                DropdownButtonFormField(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value as String;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                DropdownButtonFormField(
                  value: _selectedPaymentMethod,
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value as String;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Payment Method'),
                ),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Add Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
