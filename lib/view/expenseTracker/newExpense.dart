import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class new_expense extends StatefulWidget {
  const new_expense({super.key});

  @override
  State<new_expense> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<new_expense> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();

  List<Expense> expenseList = [];
  String? selectedCategory;
  DateTime? selectedDate; // Stores selected date

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Others"
  ];

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
          selectedCategory ?? "Others",
          double.parse(_amountController.text),
          selectedDate!,
        ));
      });

      _nameController.clear();
      _amountController.clear();
      selectedCategory = null;
      selectedDate = null;

      Navigator.of(context).pop();
    }
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Expense"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? "Enter an expense name" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(labelText: "Select Category"),
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
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Date",
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addExpense,
                child: Text("Add Expense"),
              ),
            ],
          ),
        ),
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
                      "Date: ${DateFormat.yMMMd().format(expenseList[index].date)}",
                    ),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                );
              },
            ),
    );
  }
}

class Expense {
  String name;
  String category;
  double price;
  DateTime date;

  Expense(this.name, this.category, this.price, this.date);
}
