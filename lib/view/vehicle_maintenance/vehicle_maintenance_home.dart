import 'package:flutter/material.dart';
import 'vehicle.dart'; // Model
import 'vehicle_database.dart'; // Floor DB
import 'vehicle_dao.dart'; // DAO
import 'vehicle_maintenance_form.dart'; // Form screen
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Week 9/Final Project: Home Page to list all vehicle maintenance records
class VehicleMaintenanceHome extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const VehicleMaintenanceHome({
    super.key,
    required this.onLocaleChange,
  });

  @override
  State<VehicleMaintenanceHome> createState() => _VehicleMaintenanceHomeState();
}

class _VehicleMaintenanceHomeState extends State<VehicleMaintenanceHome> {
  late VehicleDatabase database;
  late VehicleDao dao;
  List<MaintenanceRecord> records = [];

  MaintenanceRecord? selectedRecord; // For Master-Detail

  @override
  void initState() {
    super.initState();
    _setupDatabase();
  }

  Future<void> _setupDatabase() async {
    database = await $FloorVehicleDatabase.databaseBuilder('vehicle_database.db').build();
    dao = database.vehicleDao;
    await _loadRecords();
  }

  Future<void> _loadRecords() async {
    final result = await dao.findAll();
    setState(() {
      records = result;
    });
  }

  Future<void> _deleteRecord(MaintenanceRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteRecord),
        content: Text(AppLocalizations.of(context)!.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final messenger = ScaffoldMessenger.of(context);
      await dao.deleteRecord(record);
      await _loadRecords();
      if (!mounted) return;
      setState(() {
        selectedRecord = null;
      });
      messenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deletedMessage)),
      );
    }
  }
  void _changeLanguage(Locale locale) {
    widget.onLocaleChange(locale);
  }


  void _navigateToForm({MaintenanceRecord? record}) async {
    final navigator = Navigator.of(context); // Save context before async gap

    final updated = await navigator.push(
      MaterialPageRoute(
        builder: (context) => VehicleMaintenanceForm(
          record: record,
          onSave: (updatedRecord) async {
            if (record == null) {
              await dao.insertRecord(updatedRecord);
            } else {
              await dao.updateRecord(updatedRecord);
            }
            navigator.pop(true); // Return true to trigger refresh
          },
        ),
      ),
    );

    if (updated == true) {
      await _loadRecords();
    }
  }

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

  Widget _reactiveLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > size.height && size.width > 720;
    final localizations = AppLocalizations.of(context)!;

    final listWidget = ListView.builder(
      itemCount: records.length,
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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.vehicleRecords),
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

  @override
  Widget build(BuildContext context) => _reactiveLayout(context);
  }

