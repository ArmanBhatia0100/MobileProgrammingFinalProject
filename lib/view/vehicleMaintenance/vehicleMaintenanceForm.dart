import 'package:flutter/material.dart';
import 'package:mobile_programming_final_project/view/vehicleMaintenance/vehicle.dart';

/// A form page for creating or editing a [MaintenanceRecord].
class VehicleMaintenanceForm extends StatefulWidget {
  final MaintenanceRecord? record; // If null, we're adding; otherwise, editing
  final Function(MaintenanceRecord) onSave; // Callback when saved

  const VehicleMaintenanceForm({
    super.key,
    this.record,
    required this.onSave,
  });

  @override
  State<VehicleMaintenanceForm> createState() => _VehicleMaintenanceFormState();
}

class _VehicleMaintenanceFormState extends State<VehicleMaintenanceForm> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _dateController;
  late TextEditingController _mileageController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    _nameController = TextEditingController(text: record?.vehicleName ?? "");
    _typeController = TextEditingController(text: record?.vehicleType ?? "");
    _serviceTypeController = TextEditingController(text: record?.serviceType ?? "");
    _dateController = TextEditingController(text: record?.serviceDate ?? "");
    _mileageController = TextEditingController(text: record?.mileage?.toString() ?? "");
    _costController = TextEditingController(text: record?.cost?.toString() ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _serviceTypeController.dispose();
    _dateController.dispose();
    _mileageController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _submitForm() {
    try {
      final mileage = int.parse(_mileageController.text.trim());
      final cost = double.parse(_costController.text.trim());

      final record = MaintenanceRecord(
        id: widget.record?.id, // null if adding new, else use existing ID
        vehicleName: _nameController.text.trim(),
        vehicleType: _typeController.text.trim(),
        serviceType: _serviceTypeController.text.trim(),
        serviceDate: _dateController.text.trim(),
        mileage: mileage,
        cost: cost,
      );

      widget.onSave(record);
      Navigator.pop(context);
    } catch (e) {
      // Handle parsing error (e.g., invalid number)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid mileage and cost values.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Maintenance' : 'Edit Maintenance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Vehicle Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),
            TextField(
              controller: _serviceTypeController,
              decoration: const InputDecoration(labelText: 'Service Type'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Service Date'),
            ),
            TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mileage'),
            ),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cost'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}