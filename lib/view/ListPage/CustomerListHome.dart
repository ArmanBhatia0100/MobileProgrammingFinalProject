import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'CustomerDatabase.dart';
import 'CustomerBase.dart';
import 'CustomerInfo.dart';
import 'CustomerDetailsScreen.dart';
class CustomerListHome extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const CustomerListHome({super.key, required this.onLocaleChange});

  @override
  State<CustomerListHome> createState() => _CustomerListHome();
}

class _CustomerListHome extends State<CustomerListHome> {
  late final Future<CustomerDatabase> database;
  List<CustomerBase> customerList = [];
  CustomerBase? selectedCustomer;

  void _changeLanguage(Locale locale) {
    widget.onLocaleChange(locale);
  }

  @override
  void initState() {
    super.initState();
    database = $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
    loadCustomers();
  }

  /// method to get all the customers
  Future<void> loadCustomers() async {
    final db = await database;
    final customerDAO = db.customerDAO;
    final customers = await customerDAO.getAllItems();
    setState(() {
      customerList = customers;
    });
  }
  bool get isTabletOrDesktop {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width > 600; // Typical breakpoint for tablets
  }

  ///method to change the display when selecting a customer based on the size of the screen
  void selectCustomer(CustomerBase customer) {
    if (isTabletOrDesktop) {
      setState(() {
        selectedCustomer = customer;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerDetailsScreen(
            customer: customer,
            onUpdate: loadCustomers,
          ),
        ),
      );
    }
  }

  /// Navigates to the customerInfo to add new customer.
  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerInfo(),
      ),
    ).then((_) => loadCustomers());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.title),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              PopupMenuItem<Locale>(
                value: const Locale('en'),
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text('English', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('fr'),
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.red),
                    const SizedBox(width: 10),
                    Text('Français', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.language, color: Colors.black),
            offset: Offset(0, 50), // Adjust position
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToAdd,
            tooltip: localizations.addCustomer,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showInstructions(context),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: customerList.isEmpty
                ? Center(child: Text(localizations.noCustomer))
                : ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                final customer = customerList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${localizations.details} ${customer.item}"),
                    subtitle: Text("${localizations.customerId} ${customer.id}"),
                    onTap: () => selectCustomer(customer),
                  ),
                );
              },
            ),
          ),
          if (isTabletOrDesktop)
            Expanded(
              flex: 2,
              child: selectedCustomer == null
                  ?  Center(
                  child: Text(localizations.customerDetails)): CustomerDetailsScreen(
                customer: selectedCustomer!,
                onUpdate: loadCustomers,
              ),
            ),
        ],
      ),
    );
  }

  /// method to create a button that have the page instructions
  void showInstructions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.instructionsTitleAbbas),
          content: Text(localizations.customerInstructions),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.ok),
            ),
          ],
        );
      },
    );
  }
}
