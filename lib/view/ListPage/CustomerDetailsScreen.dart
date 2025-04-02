import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'CustomerBase.dart';
import 'CustomerDatabase.dart';
import 'CustomerInfo.dart';

///screen to display customer details plus buttons for delete and update
class CustomerDetailsScreen extends StatefulWidget {


  ///the customer that details will shows up
  final CustomerBase customer;

  ///function to refresh the page after update or delete
  final VoidCallback onUpdate;

  /// constructor for CustomerDetailsScreen class
  const CustomerDetailsScreen({super.key, required this.customer, required this.onUpdate});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late Future<CustomerDatabase> database;

  var _locale = Locale("en", "US");


  @override
  void initState() {
    super.initState();
    database = $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
  }

  /// displaying confirmation dialog before deleting
  Future<void> confirmDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this customer?"),
        actions: [
        TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Cancel"),
        ),
        TextButton(
        onPressed: () async {
        // Close dialog
        Navigator.pop(context);
        await deleteCustomer();
        },
        child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
        ],
        );
      },
    );
  }

  /// delete customer from database
  Future<void> deleteCustomer() async {
    final db = await database;
    final customerDAO = db.customerDAO;
    await customerDAO.deleteThisCustomer(widget.customer);

    // Refresh the list
    widget.onUpdate();
    // Close details screen
    Navigator.pop(context);
  }

  /// Navigates to the edit screen to update customer details.
  void navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerInfo(customer: widget.customer),
      ),
    ).then((_) {
      // Refresh list after update
      widget.onUpdate();
      // Close details screen after update
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.customer.item.split(',');
    return MaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', "FR"),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: _locale,


        home:  Scaffold(
          appBar: MediaQuery.of(context).size.width > 600
              ? null // No AppBar for tablet/desktop
              : AppBar(title: Text("Customer Details"),),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${'First Name: '} ${data[0]}", style: const TextStyle(fontSize: 18)),
                Text("${'Last Name: '} ${data[1]}", style: const TextStyle(fontSize: 18)),
                Text("${'Address: '} ${data[2]}", style: const TextStyle(fontSize: 18)),
                Text("${'Birthday: '} ${data[3]}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                ///buttons for delete and update
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: navigateToEdit,
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: Text('Edit Customer', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    ElevatedButton.icon(
                      onPressed: confirmDelete,
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: Text('Delete Customer', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back'),
                ),
              ],
            ),
          ),
        )
    );
  }
}
