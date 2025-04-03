class Expense {
  final int? id;
  final String name;
  final String category;
  final double amount;
  final String date;
  final String paymentMethod;

  Expense({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'date': date,
      'paymentMethod': paymentMethod,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
