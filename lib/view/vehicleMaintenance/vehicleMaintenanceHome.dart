import 'package:flutter/material.dart';

class VehicleMaintenanceHome extends StatelessWidget {
  const VehicleMaintenanceHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Maintenance")),
      body: const Center(
        child: Text("This is the Vehicle Maintenance Page"),
      ),
    );
  }
}
