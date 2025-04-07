import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_programming_final_project/view/vehicle_maintenance/vehicle.dart';
import 'vehicle_repository.dart';

class VehicleMaintenanceForm extends StatefulWidget {
  final MaintenanceRecord? record;
  final Function(MaintenanceRecord) onSave;

  const VehicleMaintenanceForm({
    super.key,
    this.record,
    required this.onSave,
  });

  @override
  State<VehicleMaintenanceForm> createState() => _VehicleMaintenanceFormState();
}

class _VehicleMaintenanceFormState extends State<VehicleMaintenanceForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _serviceTypeController;
  late final TextEditingController _dateController;
  late final TextEditingController _mileageController;
  late final TextEditingController _costController;
  late final VehicleRepository repository;

  @override
  void initState() {
    super.initState();
    final record = widget.record;

    _nameController = TextEditingController(text: record?.vehicleName ?? '');
    _typeController = TextEditingController(text: record?.vehicleType ?? '');
    _serviceTypeController = TextEditingController(text: record?.serviceType ?? '');
    _dateController = TextEditingController(text: record?.serviceDate ?? '');
    _mileageController = TextEditingController(text: record?.mileage.toString() ?? '');
    _costController = TextEditingController(text: record?.cost.toString() ?? '');

    repository = VehicleRepository();
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

  Future<void> _submitForm() async {
    try {
      final mileage = int.parse(_mileageController.text.trim());
      final cost = double.parse(_costController.text.trim());

      final record = MaintenanceRecord(
        id: widget.record?.id,
        vehicleName: _nameController.text.trim(),
        vehicleType: _typeController.text.trim(),
        serviceType: _serviceTypeController.text.trim(),
        serviceDate: _dateController.text.trim(),
        mileage: mileage,
        cost: cost,
      );

      await repository.saveLastRecord(
        name: _nameController.text,
        type: _typeController.text,
        serviceType: _serviceTypeController.text,
        date: _dateController.text,
        mileage: _mileageController.text,
        cost: _costController.text,
      );
// Ensures widget still exists before doing context-based calls
      if (!mounted) return;

      widget.onSave(record);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidInputMessage),
        ),
      );
    }
  }

  Future<void> _loadPreviousData() async {
    final data = await repository.loadLastRecord();
    setState(() {
      _nameController.text = data[VehicleRepository.keyName] ?? '';
      _typeController.text = data[VehicleRepository.keyType] ?? '';
      _serviceTypeController.text = data[VehicleRepository.keyServiceType] ?? '';
      _dateController.text = data[VehicleRepository.keyDate] ?? '';
      _mileageController.text = data[VehicleRepository.keyMileage] ?? '';
      _costController.text = data[VehicleRepository.keyCost] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null
            ? AppLocalizations.of(context)!.addMaintenance
            : AppLocalizations.of(context)!.editMaintenance),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, AppLocalizations.of(context)!.vehicleName),
            _buildTextField(_typeController, AppLocalizations.of(context)!.vehicleType),
            _buildTextField(_serviceTypeController, AppLocalizations.of(context)!.serviceType),
            _buildTextField(_dateController, AppLocalizations.of(context)!.serviceDate),
            _buildTextField(_mileageController, AppLocalizations.of(context)!.mileage, isNumeric: true),
            _buildTextField(_costController, AppLocalizations.of(context)!.cost, isNumeric: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadPreviousData,
              child: Text(AppLocalizations.of(context)!.loadPrevious),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    );
  }
}
