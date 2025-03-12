import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();

  List<Expense> expenseList = [];
  String? selectedCategory;
  String? selectedPayment;
  DateTime? selectedDate;

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Others"
  ];

  final List<String> paymentMethods = ["Cash", "Credit Card"];

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _addExpense() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      setState(() {
        expenseList.add(Expense(
          _nameController.text,
          selectedPayment!,
          selectedCategory ?? "Others",
          double.parse(_amountController.text),
          selectedDate!,
        ));
      });
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void _updateExpense(int index) {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      setState(() {
        expenseList[index] = Expense(
          _nameController.text,
          selectedPayment!,
          selectedCategory ?? "Others",
          double.parse(_amountController.text),
          selectedDate!,
        );
      });
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      expenseList.removeAt(index);
    });
    _clearForm();
    Navigator.of(context).pop();
  }

  void _clearForm() {
    _nameController.clear();
    _amountController.clear();
    selectedCategory = null;
    selectedPayment = null;
    selectedDate = null;
  }

  void _showAddExpenseDialog() {
    _clearForm();
    _showExpenseDialog(title: "Add Expense", onSubmit: _addExpense);
  }

  void _showEditExpenseDialog(int index) {
    final expense = expenseList[index];
    _nameController.text = expense.name;
    _amountController.text = expense.price.toString();
    selectedCategory = expense.category;
    selectedPayment = expense.payment;
    selectedDate = expense.date;

    _showExpenseDialog(
      title: "Edit Expense",
      onSubmit: () => _updateExpense(index),
      onDelete: () => _deleteExpense(index),
      index: index,
    );
  }

  void _showExpenseDialog({
    required String title,
    required VoidCallback onSubmit,
    VoidCallback? onDelete,
    int? index,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) =>
                  value!.isEmpty ? "Enter an expense name" : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedPayment,
                  decoration: InputDecoration(labelText: "Payment Method"),
                  items: paymentMethods.map((payment) {
                    return DropdownMenuItem(
                      value: payment,
                      child: Text(payment),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? "Select a payment method" : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: "Category"),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? "Select a category" : null,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter amount" : null,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ""
                        : DateFormat.yMMMd().format(selectedDate!),
                  ),
                  validator: (value) =>
                  selectedDate == null ? "Select a date" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (onDelete != null)
            TextButton(
              onPressed: onDelete,
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(title.startsWith("Add") ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _showAddExpenseDialog,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: expenseList.isEmpty
          ? Center(child: Text("No expenses added yet!"))
          : ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(expenseList[index].name),
              subtitle: Text(
                "${expenseList[index].category} - \$${expenseList[index].price.toStringAsFixed(2)}\n"
                    "Date: ${DateFormat.yMMMd().format(expenseList[index].date)} \n${expenseList[index].payment}",
              ),
              trailing: Icon(Icons.edit),
              onTap: () => _showEditExpenseDialog(index),
            ),
          );
        },
      ),
    );
  }
}

class Expense {
  String name;
  String payment;
  String category;
  double price;
  DateTime date;

  Expense(this.name, this.payment, this.category, this.price, this.date);
}