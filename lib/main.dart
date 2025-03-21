import 'package:flutter/material.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerForm.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/EventPlannerHome.dart';
import 'package:mobile_programming_final_project/view/eventPlanner/eventdatabase.dart';
import 'package:mobile_programming_final_project/view/expenseTracker/ExpenseTrackerHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final eventdatabase = await $FloorEventDatabase.databaseBuilder('event.db').build();
  runApp(MyApp(eventdatabase));
}

class MyApp extends StatelessWidget {
  final EventDatabase eventdatabase;
  MyApp(this.eventdatabase);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes:{
        "/":(context)=>MyHomePage(title: 'Team One Final project'),
        "/eventplanner":(context) => EventPlannerHome(eventdatabase: eventdatabase),
        "/expense":(context) => Expensetrackerhome(),
        "/eventplannerform":(context) => EventPlannerForm(eventdatabase: eventdatabase,),
      } ,
    );
  }
}

class ExpenseTrackerHome {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child:
        Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
        OutlinedButton(onPressed: (){
          Navigator.pushNamed(context, "/eventplanner");
        }, child: Text("Event Planner")),
        OutlinedButton(onPressed: (){}, child: Text("Page 2")),
        OutlinedButton(onPressed: (){
          Navigator.pushNamed(context, "/expense");
        }, child: Text("Expense Tracker")),
        OutlinedButton(onPressed: (){}, child: Text("Page 3"))
      ],),),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
