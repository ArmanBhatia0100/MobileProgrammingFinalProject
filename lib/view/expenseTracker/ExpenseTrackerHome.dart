import 'package:flutter/material.dart';


class Expensetrackerhome extends StatefulWidget {
  const Expensetrackerhome({super.key});

  @override
  State<Expensetrackerhome> createState() => _ExpensetrackerhomeState();
}

class _ExpensetrackerhomeState extends State<Expensetrackerhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Expense Tracker"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){}, child: Text("Add Expense")),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
          itemBuilder: (context,index){
        return Card(
          child: ListTile(
            title: Text("one"),
            subtitle: Text("Description of "),
            leading: Icon(Icons.list),
            trailing: Icon(Icons.arrow_forward),
          ),
        );
      }),
    );
  }
}
