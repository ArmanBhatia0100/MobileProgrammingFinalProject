import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'CustomerDatabase.dart';
import 'CustomerBase.dart';
import 'repository.dart';

///class for adding or editing customer information
class CustomerInfo extends StatefulWidget {
  /// The customer being edited, or `null` for a new customer.
  final CustomerBase? customer;

  ///constructor
  const CustomerInfo({super.key, this.customer});

  @override
  State<CustomerInfo> createState() => _CustomerInfo();
}

class _CustomerInfo extends State<CustomerInfo> {
  late final Future<CustomerDatabase> database;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController birthdayController;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Repository instance
  final Repository repository = Repository();

  ///id of the customer being edited
  int? customerId;

  @override
  void initState() {
    super.initState();
    database =
        $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
    loadPreviousCustomer();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    birthdayController = TextEditingController();

    if (widget.customer != null) {
      customerId = widget.customer!.id;
      final data = widget.customer!.item.split(',');
      firstNameController.text = data[0];
      lastNameController.text = data[1];
      addressController.text = data[2];
      birthdayController.text = data[3];
    }
  }

  ///load last customer saved data
  Future<void> loadPreviousCustomer() async {
    final previousData = await repository.loadProfileData();
    setState(() {
      firstNameController.text = previousData['first_name'] ?? '';
      lastNameController.text = previousData['last_name'] ?? '';
      addressController.text = previousData['address'] ?? '';
      birthdayController.text = previousData['birthday'] ?? '';
    });
  }

  /// save customer information in the database and encryptedReference
  Future<void> saveProfileData() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    final db = await database;
    final customerDAO = db.customerDAO;
    final customerData =
        '${firstNameController.text},${lastNameController.text},${addressController.text},${birthdayController.text}';

    if (customerId == null) {
      // auto increment ID
      final newCustomer = CustomerBase(null, customerData);
      await customerDAO.insertCustomer(newCustomer);

      // Show success SnackBar before navigation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate("save_customer")!),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      // Delay the navigation to allow SnackBar to be visible
      await Future.delayed(Duration(milliseconds: 2200));
    } else {
      final updatedCustomer = CustomerBase(customerId!, customerData);
      await customerDAO.updateCustomer(updatedCustomer);
    }

    // Save customer details in EncryptedSharedPreferences
    await repository.saveProfileData(
      firstNameController.text,
      lastNameController.text,
      addressController.text,
      birthdayController.text,
    );

    // Only pop after everything is done
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(customerId == null
            ? AppLocalizations.of(context)!.translate("add_customer")!
            : AppLocalizations.of(context)!.translate("edit_customer")!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate("first_name")!,
                ),
                validator: (value) =>
                value!.isEmpty ? AppLocalizations.of(context)!.translate("empty_value")! : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate("last_name")!,
                ),
                validator: (value) =>
                value!.isEmpty ? AppLocalizations.of(context)!.translate("empty_value")! : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate("address")!,
                ),
                validator: (value) =>
                value!.isEmpty ? AppLocalizations.of(context)!.translate("empty_value")! : null,
              ),
              TextFormField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate("birthday")!,
                ),
                validator: (value) =>
                value!.isEmpty ? AppLocalizations.of(context)!.translate("empty_value")! : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveProfileData,
                    child: Text(customerId == null
                        ? AppLocalizations.of(context)!.translate("save_customer")!
                        : AppLocalizations.of(context)!.translate("update_customer")!),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.translate("back_button")!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}