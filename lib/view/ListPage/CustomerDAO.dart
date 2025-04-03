import 'package:floor/floor.dart';

import 'CustomerBase.dart';

@dao
abstract class CustomerDAO {
  ///gets all customers in the database
  @Query('SELECT * FROM CustomerBase')
  Future<List<CustomerBase>> getAllItems();

  ///DAO Insert method
  @insert
  Future<void> insertCustomer(CustomerBase itm);

  /// DAO update method
  @update
  Future<void> updateCustomer(CustomerBase itm);

  ///DAO Delete method
  @delete
  Future<void> deleteThisCustomer(CustomerBase itm);
}
