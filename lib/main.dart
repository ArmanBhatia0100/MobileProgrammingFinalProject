import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/eventPlanner_localizations.dart';

import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerForm.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerHome.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/eventdatabase.dart';
import 'package:mobile_programming_final_project/view/expenseTracker/ExpenseTrackerHome.dart';

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
      title: 'Event Planner App',
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
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Team One Final Project'),
        '/eventplanner': (context) => EventPlannerHome(
          eventdatabase: widget.eventdatabase,
          onLocaleChange: _changeLocale,
        ),
        '/expense': (context) => Expensetrackerhome(),
        '/eventplannerform': (context) => EventPlannerForm(
          eventdatabase: widget.eventdatabase,
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
              onPressed: () {},
              child: const Text("Page 2"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, "/expense"),
              child: const Text("Expense Tracker"),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text("Page 3"),
            ),
          ],
        ),
      ),
    );
  }
}
