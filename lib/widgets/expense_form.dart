import 'package:flutter/material.dart';

class ExpenseForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final TextEditingController paymentMethodController;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final VoidCallback onSubmit;

  const ExpenseForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.amountController,
    required this.categoryController,
    required this.paymentMethodController,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Expense Name'),
              validator: (value) => value!.isEmpty ? 'Enter an expense name' : null,
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) => value!.isEmpty ? 'Enter an amount' : null,
            ),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
              validator: (value) => value!.isEmpty ? 'Enter a category' : null,
            ),
            TextFormField(
              controller: paymentMethodController,
              decoration: const InputDecoration(labelText: 'Payment Method'),
              validator: (value) => value!.isEmpty ? 'Enter a payment method' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      onDateChanged(pickedDate);
                    }
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
