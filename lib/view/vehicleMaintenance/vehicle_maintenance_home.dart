import 'package:flutter/material.dart';
import 'vehicle.dart'; // Model
import 'vehicle_database.dart'; // Floor DB
import 'vehicle_dao.dart'; // DAO
import 'vehicle_maintenance_form.dart'; // Form screen

// Week 9/Final Project: Home Page to list all vehicle maintenance records
class VehicleMaintenanceHome extends StatefulWidget {
  const VehicleMaintenanceHome({super.key});

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
    final messenger = ScaffoldMessenger.of(context); // Save early

    await dao.deleteRecord(record);
    await _loadRecords();
    setState(() {
      selectedRecord = null;
    });

    messenger.showSnackBar(
      const SnackBar(content: Text("Record deleted")),
    );
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


  // Week 9: Responsive layout handler
  Widget _reactiveLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > size.height && size.width > 720;

    if (isWideScreen) {
      // Master-Detail layout for tablet
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildList(),
          ),
          Expanded(
            flex: 3,
            child: selectedRecord != null
                ? _buildDetails(selectedRecord!)
                : const Center(child: Text("Select a record")),
          ),
        ],
      );
    } else {
      // Portrait mode or phone layout
      return selectedRecord == null ? _buildList() : _buildDetails(selectedRecord!);
    }
  }

  Widget _buildList() {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Maintenance Records")),
      body: records.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetails(MaintenanceRecord record) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vehicle: ${record.vehicleName}", style: Theme.of(context).textTheme.headlineMedium),
            Text("Type: ${record.vehicleType}"),
            Text("Service: ${record.serviceType}"),
            Text("Date: ${record.serviceDate}"),
            Text("Mileage: ${record.mileage} km"),
            Text("Cost: \$${record.cost}"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToForm(record: record),
                  child: const Text("Update"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _deleteRecord(record),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => selectedRecord = null),
                  child: const Text("Close"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _reactiveLayout(context);
  }
}
