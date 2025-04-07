import 'package:flutter/material.dart';
// import 'package:mobile_programming_final_project/view/ListPage/AppLocalizations.dart';
import 'package:mobile_programming_final_project/view/ListPage/CustomerListHome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerForm.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerHome.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/eventdatabase.dart';
import 'package:mobile_programming_final_project/view/vehicle_maintenance/vehicle_maintenance_home.dart';
import 'package:mobile_programming_final_project/view/vehicle_maintenance/vehicle_maintenance_form.dart';
import 'pages/home_page.dart';
import 'pages/expense_page.dart';
import 'pages/add_expense.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final eventdatabase = await $FloorEventDatabase.databaseBuilder('event.db').build();
  runApp(MyApp(eventdatabase: eventdatabase));
}

class MyApp extends StatefulWidget {
  final EventDatabase eventdatabase;

  const MyApp({super.key, required this.eventdatabase});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default language

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Group project',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24.0),
          bodyLarge: TextStyle(fontSize: 16.0),
        ),
      ),
      initialRoute: '/',

//       routes:{
//         "/":(context)=>const MyHomePage(title: 'Team One Final project'),
//         "/expense":(context)=>const Expensetrackerhome(),
//         "/customer":(context)=> CustomerListHome(
//           onLocaleChange: _changeLocale,
//         ),
//       } ,

      routes: {
        '/': (context) => MyHomePage(title: 'Team One Final Project'),
        '/eventplanner': (context) => EventPlannerHome(
          eventdatabase: widget.eventdatabase,
          onLocaleChange: _changeLocale,
        ),
        '/expense': (context) => const ExpensePage(),
        '/add-expense': (context) => AddExpensePage(),
        '/eventplannerform': (context) => EventPlannerForm(
          eventdatabase: widget.eventdatabase,
        ),
        "/customer":(context)=> CustomerListHome(
          onLocaleChange: _changeLocale,
        ),
        '/vehicle': (context) => VehicleMaintenanceHome(
          onLocaleChange: _changeLocale,
        ),
        '/vehicle-form': (context) => VehicleMaintenanceForm(
          onSave: (_) {}, // placeholder; actual use will override via
        ),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, "/eventplanner"),
              child: const Text("Event Planner"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, "/customer"),
              child: const Text("Customer List"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, "/expense"),
              child: const Text("Expense Tracker"),
            ),
            OutlinedButton(
              onPressed: ()  => Navigator.pushNamed(context, "/vehicle"),
              child: const Text("Vehicle Maintenance"),
            ),
          ],
        ),
      ),
    );
  }
}
