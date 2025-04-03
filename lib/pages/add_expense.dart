import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/expense.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

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
    return result ?? false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense'),
          centerTitle: true,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expense Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Expense Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter expense name' : null,
                  ),
                  const SizedBox(height: 16.0),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter amount' : null,
                  ),
                  const SizedBox(height: 16.0),

                  // Category Dropdown
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
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Payment Method Dropdown
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
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Date Picker
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${_selectedDate.toLocal()}".split(' ')[0]),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addExpense,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 3,
                      ),
                      child: const Text('Add Expense', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}