import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_programming_final_project/view/vehicle_maintenance/vehicle.dart';
import 'vehicle_repository.dart';
/// Represents a form for adding or editing vehicle maintenance records
class VehicleMaintenanceForm extends StatefulWidget {
  final MaintenanceRecord? record; // null = add, not null = edit
  final Function(MaintenanceRecord) onSave;
/// Constructor for the VehicleMaintenanceForm
  const VehicleMaintenanceForm({
    super.key,
    this.record,
    required this.onSave,
  });

  @override
  State<VehicleMaintenanceForm> createState() => _VehicleMaintenanceFormState();
}
/// State class for VehicleMaintenanceForm
class _VehicleMaintenanceFormState extends State<VehicleMaintenanceForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _serviceTypeController;
  late final TextEditingController _dateController;
  late final TextEditingController _mileageController;
  late final TextEditingController _costController;
  late final VehicleRepository repository;

  final _formKey = GlobalKey<FormState>();
/// Initialize controllers and repository
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
/// Dispose controllers to free up resources
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
/// Submit the form data
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
/// Save the record to the database
      await repository.saveLastRecord(
        name: _nameController.text,
        type: _typeController.text,
        serviceType: _serviceTypeController.text,
        date: _dateController.text,
        mileage: _mileageController.text,
        cost: _costController.text,
      );
/// Call the onSave callback
      widget.onSave(record);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalidInputMessage)),
      );
    }
  }
/// Load previous data from the repository
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

/// Build the form UI
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
/// Set the title based on whether it's adding or editing a record
    return Scaffold(
      /// AppBar with title and action buttons
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.record == null
            ? localizations.addMaintenance
            : localizations.editMaintenance),
        actions: [
          /// Button to load previous data
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: localizations.loadPrevious,
            onPressed: _loadPreviousData,
          ),
          /// Button to save the form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.record == null
                  ? localizations.add
                  : localizations.save),
            ),
          )
        ],
      ),
      /// Main body of the form
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              /// Form fields for vehicle details
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// TextFormField for vehicle name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: localizations.vehicleName),
                    validator: (value) =>
                    value == null || value.isEmpty ? localizations.emptyValue : null,
                  ),
                  /// TextFormField for vehicle type
                  TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(labelText: localizations.vehicleType),
                    validator: (value) =>
                    value == null || value.isEmpty ? localizations.emptyValue : null,
                  ),
                  /// TextFormField for service type
                  TextFormField(
                    controller: _serviceTypeController,
                    decoration: InputDecoration(labelText: localizations.serviceType),
                    validator: (value) =>
                    value == null || value.isEmpty ? localizations.emptyValue : null,
                  ),
                  /// Date picker for service date
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text = pickedDate.toString().split(' ')[0];
                        });
                      }
                    },
                    /// TextFormField for service date
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: localizations.serviceDate,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? localizations.emptyValue
                            : null,
                      ),
                    ),
                  ),
                  /// TextFormField for mileage
                  TextFormField(
                    controller: _mileageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: localizations.mileage),
                    validator: (value) =>
                    value == null || value.isEmpty ? localizations.emptyValue : null,
                  ),
                  /// TextFormField for cost
                  TextFormField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: localizations.cost),
                    validator: (value) =>
                    value == null || value.isEmpty ? localizations.emptyValue : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
