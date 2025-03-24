// lib/widgets/expense_detail.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/db_helper.dart';

class ExpenseDetail extends StatefulWidget {
  final Expense expense;
  final Function onExpenseUpdated;

  const ExpenseDetail({super.key, required this.expense, required this.onExpenseUpdated});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Entertainment', 'Health', 'Other'];
  final List<String> _paymentMethods = ['Cash', 'Credit', 'Debit'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _amountController = TextEditingController(text: widget.expense.amount.toString());

    // Ensure _selectedCategory is a valid value from _categories
    _selectedCategory = _categories.contains(widget.expense.category)
        ? widget.expense.category
        : _categories.first; // Fallback to first item if not found

    // Ensure _selectedPaymentMethod is a valid value from _paymentMethods
    _selectedPaymentMethod = _paymentMethods.contains(widget.expense.paymentMethod)
        ? widget.expense.paymentMethod
        : _paymentMethods.first; // Fallback to first item if not found

    _selectedDate = DateTime.parse(widget.expense.date);
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

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        id: widget.expense.id,
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate.toString(),
        paymentMethod: _selectedPaymentMethod,
      );
      await DatabaseHelper.instance.updateExpense(updatedExpense);
      widget.onExpenseUpdated();
      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  void _deleteExpense() async {
    await DatabaseHelper.instance.deleteExpense(widget.expense.id!);
    widget.onExpenseUpdated();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter expense name' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter an amount';
                    if (double.tryParse(value) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveExpense,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 16.0)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this expense?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteExpense();
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Text('Delete', style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}