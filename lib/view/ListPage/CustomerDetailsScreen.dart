import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.deleteCustomer),
          content: Text(AppLocalizations.of(context)!.confirmDelete),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteCustomer();
              },
              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
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

    widget.onUpdate();
    Navigator.pop(context);
  }

  /// Navigates to the edit screen to update customer details.
  void navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerInfo(
          customer: widget.customer,
        ),
      ),
    ).then((_) {
      widget.onUpdate();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.customer.item.split(',');
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > 600
          ? null
          : AppBar(
        title: Text(AppLocalizations.of(context)!.customerDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${AppLocalizations.of(context)!.firstName} ${data[0]}", style: const TextStyle(fontSize: 18)),
            Text("${AppLocalizations.of(context)!.lastName} ${data[1]}", style: const TextStyle(fontSize: 18)),
            Text("${AppLocalizations.of(context)!.address} ${data[2]}", style: const TextStyle(fontSize: 18)),
            Text("${AppLocalizations.of(context)!.birthday} ${data[3]}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            ///buttons for delete and update
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: navigateToEdit,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(AppLocalizations.of(context)!.editCustomer, style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: confirmDelete,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(AppLocalizations.of(context)!.deleteCustomer, style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.backButton),
            ),
          ],
        ),
      ),
    );
  }
}