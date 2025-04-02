

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


import 'CustomerBase.dart';
import 'CustomerDAO.dart';

part 'CustomerDatabase.g.dart';

///customer database
@Database(version:1, entities: [CustomerBase])
abstract class CustomerDatabase extends FloorDatabase {

  ///giving access to DAO
  CustomerDAO get customerDAO;
}