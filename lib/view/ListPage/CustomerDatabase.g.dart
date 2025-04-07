// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $CustomerDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $CustomerDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $CustomerDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<CustomerDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorCustomerDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomerDatabaseBuilderContract databaseBuilder(String name) =>
      _$CustomerDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomerDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$CustomerDatabaseBuilder(null);
}

class _$CustomerDatabaseBuilder implements $CustomerDatabaseBuilderContract {
  _$CustomerDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $CustomerDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $CustomerDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<CustomerDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CustomerDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CustomerDatabase extends CustomerDatabase {
  _$CustomerDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CustomerDAO? _customerDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CustomerBase` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `item` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CustomerDAO get customerDAO {
    return _customerDAOInstance ??= _$CustomerDAO(database, changeListener);
  }
}

class _$CustomerDAO extends CustomerDAO {
  _$CustomerDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerBaseInsertionAdapter = InsertionAdapter(
            database,
            'CustomerBase',
            (CustomerBase item) =>
                <String, Object?>{'id': item.id, 'item': item.item}),
        _customerBaseUpdateAdapter = UpdateAdapter(
            database,
            'CustomerBase',
            ['id'],
            (CustomerBase item) =>
                <String, Object?>{'id': item.id, 'item': item.item}),
        _customerBaseDeletionAdapter = DeletionAdapter(
            database,
            'CustomerBase',
            ['id'],
            (CustomerBase item) =>
                <String, Object?>{'id': item.id, 'item': item.item});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CustomerBase> _customerBaseInsertionAdapter;

  final UpdateAdapter<CustomerBase> _customerBaseUpdateAdapter;

  final DeletionAdapter<CustomerBase> _customerBaseDeletionAdapter;

  @override
  Future<List<CustomerBase>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM CustomerBase',
        mapper: (Map<String, Object?> row) =>
            CustomerBase(row['id'] as int?, row['item'] as String));
  }

  @override
  Future<void> insertCustomer(CustomerBase itm) async {
    await _customerBaseInsertionAdapter.insert(itm, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCustomer(CustomerBase itm) async {
    await _customerBaseUpdateAdapter.update(itm, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteThisCustomer(CustomerBase itm) async {
    await _customerBaseDeletionAdapter.delete(itm);
  }
}
