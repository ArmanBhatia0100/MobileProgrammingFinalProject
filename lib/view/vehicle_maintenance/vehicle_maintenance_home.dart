import 'package:flutter/material.dart';
import 'vehicle.dart'; // Model
import 'vehicle_database.dart'; // Floor DB
import 'vehicle_dao.dart'; // DAO
import 'vehicle_maintenance_form.dart'; // Form screen
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// This is the main screen for the Vehicle Maintenance app
class VehicleMaintenanceHome extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const VehicleMaintenanceHome({
    super.key,
    required this.onLocaleChange,
  });
/// This widget is the home page of the application.
  @override
  State<VehicleMaintenanceHome> createState() => _VehicleMaintenanceHomeState();
}
/// This is the state for the VehicleMaintenanceHome widget
class _VehicleMaintenanceHomeState extends State<VehicleMaintenanceHome> {
  late VehicleDatabase database;
  late VehicleDao dao;
  List<MaintenanceRecord> records = [];

  MaintenanceRecord? selectedRecord; // For Master-Detail
/// This method is called when the widget is first created
  @override
  void initState() {
    super.initState();
    _setupDatabase();
  }
/// This method sets up the database and loads existing records
  Future<void> _setupDatabase() async {
    database = await $FloorVehicleDatabase.databaseBuilder('vehicle_database.db').build();
    dao = database.vehicleDao;
    await _loadRecords();
  }
/// This method loads all records from the database
  Future<void> _loadRecords() async {
    final result = await dao.findAll();
    setState(() {
      records = result;
    });
  }
/// This method deletes a record after user confirmation
  Future<void> _deleteRecord(MaintenanceRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      /// This method shows a confirmation dialog before deleting a record
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteRecord),
        content: Text(AppLocalizations.of(context)!.confirmDelete),
        actions: [
          /// Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          /// Confirm button
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
/// If the user confirms, delete the record
    if (confirm == true) {
      /// Delete the record from the database
      final messenger = ScaffoldMessenger.of(context);
      /// Show a snackbar message
      await dao.deleteRecord(record);
      /// Reload the records
      await _loadRecords();
      /// Show a snackbar message
      if (!mounted) return;
      setState(() {
        selectedRecord = null;
      });
      /// Show a snackbar message
      messenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deletedMessage)),
      );
    }
  }
  /// This method changes the app's language
  void _changeLanguage(Locale locale) {
    widget.onLocaleChange(locale);
  }

/// This method navigates to the form screen for adding or updating a record
  void _navigateToForm({MaintenanceRecord? record}) async {
    final navigator = Navigator.of(context); // Save context before async gap
/// This method shows the form screen for adding or updating a record
    final updated = await navigator.push(
      /// This method pushes the form screen onto the navigation stack
      MaterialPageRoute(
        /// This method creates the form screen
        builder: (context) => VehicleMaintenanceForm(
          record: record,
          /// This method is called when the form is saved
          onSave: (updatedRecord) async {
            if (record == null) {
              /// If no record is passed, insert a new record
              await dao.insertRecord(updatedRecord);
            } else {
              /// If a record is passed, update the existing record
              await dao.updateRecord(updatedRecord);
            }
            /// Show a snackbar message
            navigator.pop(true); // Return true to trigger refresh
          },
        ),
      ),
    );

    if (updated == true) {
      await _loadRecords();
    }
  }
/// This method shows the instructions dialog
  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.instructionsTitle),
        content: Text(AppLocalizations.of(context)!.vehicleInstructions),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
/// This method builds the layout based on the screen size
  Widget _reactiveLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > size.height && size.width > 720;
    final localizations = AppLocalizations.of(context)!;
/// This method builds the list of records and details
    final listWidget = ListView.builder(
      itemCount: records.length,
      /// This method builds the list of records
      itemBuilder: (context, index) {
        final record = records[index];
        return ListTile(
          title: Text(record.vehicleName),
          subtitle: Text("${record.serviceType} - ${record.serviceDate}"),
          onTap: () {
            setState(() {
              selectedRecord = record;
            });
          },
        );
      },
    );
    /// This method builds the details of the selected record
      final detailsWidget = selectedRecord != null
        ? Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Vehicle: ${selectedRecord!.vehicleName}",
              style: Theme.of(context).textTheme.headlineMedium),
          Text("Type: ${selectedRecord!.vehicleType}"),
          Text("Service: ${selectedRecord!.serviceType}"),
          Text("Date: ${selectedRecord!.serviceDate}"),
          Text("Mileage: ${selectedRecord!.mileage} km"),
          Text("Cost: \$${selectedRecord!.cost}"),
          const SizedBox(height: 20),
          /// This method shows the buttons for updating and deleting the record
          Row(
            children: [

              ElevatedButton(
                onPressed: () => _navigateToForm(record: selectedRecord),
                child: Text(localizations.update),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _deleteRecord(selectedRecord!),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(localizations.delete),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => selectedRecord = null),
                child: Text(localizations.close),
              ),
            ],
          )
        ],
      ),
    )
        : const Center(child: Text("Select a record"));
    return Scaffold(
      /// AppBar with title and action buttons
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.vehicleRecords),
        /// Action buttons for adding, showing instructions, and changing language
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: localizations.addMaintenance,
            onPressed: () => _navigateToForm(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: localizations.instructionsTitle,
            onPressed: () => _showInstructions(context),
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: const Text('English'),
              ),
              PopupMenuItem(
                value: const Locale('fr'),
                child: const Text('Français'),
              ),
            ],
          ),
        ],
      ),
      body: records.isEmpty
          ? Center(child: Text(localizations.noRecords))
          : isWideScreen
          ? Row(
        children: [
          Expanded(flex: 2, child: listWidget),
          const VerticalDivider(width: 1),
          Expanded(flex: 3, child: detailsWidget),
        ],
      )
          : selectedRecord == null
          ? listWidget
          : detailsWidget,
    );
  }
/// This method builds the widget tree
  @override
  Widget build(BuildContext context) => _reactiveLayout(context);
  }

