import 'package:floor/floor.dart';

@entity
class CustomerBase {
  /// Unique ID for a customer
  @PrimaryKey(autoGenerate: true)
  final int? id;

  ///storing customer information
  final String item;

  ///constructor for entity
  CustomerBase(this.id, this.item);
}
