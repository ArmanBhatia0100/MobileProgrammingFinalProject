import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

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

  final List<String> categories = ["Food", "Travel", "Shopping", "Bills", "Others"];
  final List<String> paymentMethods = ["Cash", "Credit Card"];

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
          selectedPayment!,
          selectedCategory ?? "Others",
          double.parse(_amountController.text),
          selectedDate!,
        ));
      });

      _nameController.clear();
      _amountController.clear();
      selectedCategory = null;
      selectedPayment = null;
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
                validator: (value) => value!.isEmpty ? "Enter an expense name" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedPayment,
                decoration: InputDecoration(labelText: "Select Payment Method"),
                items: paymentMethods.map((payment) {
                  return DropdownMenuItem(value: payment, child: Text(payment));
                }).toList(),
                onChanged: (value) => setState(() => selectedPayment = value),
                validator: (value) => value == null ? "Select a payment method" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(labelText: "Select Category"),
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                validator: (value) => value == null ? "Select a category" : null,
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
                  labelText: "Select Date",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context),
                  ),
                ),
                controller: TextEditingController(
                  text: selectedDate == null ? "" : DateFormat.yMMMd().format(selectedDate!),
                ),
                validator: (value) => selectedDate == null ? "Select a date" : null,
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

  void _showExpenseDetails(Expense expense, int index) {
    TextEditingController nameController = TextEditingController(text: expense.name);
    TextEditingController amountController = TextEditingController(text: expense.price.toString());
    String? category = expense.category;
    String? payment = expense.payment;
    DateTime? date = expense.date;

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(title: Text("Expense Details")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Expense Name"),
                ),
                DropdownButtonFormField<String>(
                  value: payment,
                  decoration: InputDecoration(labelText: "Payment Method"),
                  items: paymentMethods.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) => setState(() => payment = value),
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(labelText: "Category"),
                  items: categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) => setState(() => category = value),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() => date = pickedDate);
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: date == null ? "" : DateFormat.yMMMd().format(date!),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          expenseList[index] = Expense(
                            nameController.text,
                            payment!,
                            category!,
                            double.parse(amountController.text),
                            date!,
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Save Changes"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          expenseList.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Delete", style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Tracker"), actions: [
        IconButton(onPressed: _showAddExpenseDialog, icon: Icon(Icons.add)),
      ]),
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
                    "Date: ${DateFormat.yMMMd().format(expenseList[index].date)}\n"
                    "${expenseList[index].payment}",
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _showExpenseDetails(expenseList[index], index),
            ),
          );
        },
      ),
    );
  }
}

class Expense {
  String name, payment, category;
  double price;
  DateTime date;
  Expense(this.name, this.payment, this.category, this.price, this.date);
}
