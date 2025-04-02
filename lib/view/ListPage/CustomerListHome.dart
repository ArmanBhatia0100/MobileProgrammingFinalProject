import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'CustomerDatabase.dart';
import 'CustomerBase.dart';
import 'CustomerInfo.dart';
import 'CustomerDetailsScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CustomerListHome extends StatefulWidget {
  const CustomerListHome({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _CustomerListHome? state = context.findAncestorStateOfType<_CustomerListHome>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<CustomerListHome> createState() => _CustomerListHome();
}

class _CustomerListHome extends State<CustomerListHome> {
  var _locale = Locale("en", "US");

  void changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', "US"),
        Locale('fr', "FR"),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      home: const MyHomePage(title: 'Customer List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<CustomerDatabase> database;
  List<CustomerBase> customerList = [];
  CustomerBase? selectedCustomer;

  @override
  void initState() {
    super.initState();
    database = $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final db = await database;
    final customerDAO = db.customerDAO;
    final customers = await customerDAO.getAllItems();
    setState(() {
      customerList = customers;
    });
  }

  void selectCustomer(CustomerBase customer, bool isTabletOrDesktop) {
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

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerInfo(),
      ),
    ).then((_) => loadCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(AppLocalizations.of(context)!.translate("title")!),
        actions: [
          OutlinedButton(
            child: Text(AppLocalizations.of(context)!.translate("English")!),
            onPressed: () {
              CustomerListHome.setLocale(context, Locale('en', "US"));
            },
          ),
          OutlinedButton(
            child: Text(AppLocalizations.of(context)!.translate("French")!),
            onPressed: () {
              CustomerListHome.setLocale(context, Locale('fr', "FR"));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToAdd,
            tooltip: AppLocalizations.of(context)!.translate("add_customer")!,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: customerList.isEmpty
                ? Center(child: Text("No customer available"))
                : ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                final customer = customerList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Details: ${customer.item}"),
                    subtitle: Text("Customer ID: ${customer.id}"),
                    onTap: () => selectCustomer(customer, true),
                  ),
                );
              },
            ),
          ),
          // if (isTabletOrDesktop)
          //   Expanded(
          //     flex: 2,
          //     child: selectedCustomer == null
          //         ?  Center(
          //         child: Text("Select a customer to view details")): CustomerDetailsScreen(
          //       customer: selectedCustomer!,
          //       onUpdate: () {},
          //     ),
          //   ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        tooltip: "Add Customer",
        child: const Icon(Icons.add),
      ),
    );
  }

  void showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How to Use the Interface"),
          content: Text("1. Tap '+' to add a new customer.\n2. Tap on a customer to view details and manage it."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
