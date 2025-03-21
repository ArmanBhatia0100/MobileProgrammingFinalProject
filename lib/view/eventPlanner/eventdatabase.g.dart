// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventdatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $EventDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $EventDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $EventDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<EventDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorEventDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $EventDatabaseBuilderContract databaseBuilder(String name) =>
      _$EventDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $EventDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$EventDatabaseBuilder(null);
}

class _$EventDatabaseBuilder implements $EventDatabaseBuilderContract {
  _$EventDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $EventDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $EventDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<EventDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$EventDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$EventDatabase extends EventDatabase {
  _$EventDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EventDao? _eventDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Event` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `number_of_attendees` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EventDao get eventDao {
    return _eventDaoInstance ??= _$EventDao(database, changeListener);
  }
}

class _$EventDao extends EventDao {
  _$EventDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _eventInsertionAdapter = InsertionAdapter(
            database,
            'Event',
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'number_of_attendees': item.number_of_attendees
                }),
        _eventUpdateAdapter = UpdateAdapter(
            database,
            'Event',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'number_of_attendees': item.number_of_attendees
                }),
        _eventDeletionAdapter = DeletionAdapter(
            database,
            'Event',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'number_of_attendees': item.number_of_attendees
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Event> _eventInsertionAdapter;

  final UpdateAdapter<Event> _eventUpdateAdapter;

  final DeletionAdapter<Event> _eventDeletionAdapter;

  @override
  Future<Event?> findEventById(int id) async {
    return _queryAdapter.query('SELECT * FROM Event WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Event(row['title'] as String,
            row['description'] as String, row['number_of_attendees'] as String,
            id: row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Event>> getAllEvents() async {
    return _queryAdapter.queryList('SELECT * FROM Event',
        mapper: (Map<String, Object?> row) => Event(row['title'] as String,
            row['description'] as String, row['number_of_attendees'] as String,
            id: row['id'] as int?));
  }

  @override
  Future<void> deleteEventById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Event WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertEvent(Event event) async {
    await _eventInsertionAdapter.insert(event, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEvent(Event event) async {
    await _eventUpdateAdapter.update(event, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEvent(Event event) async {
    await _eventDeletionAdapter.delete(event);
  }
}
