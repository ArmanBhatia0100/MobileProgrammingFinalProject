import 'package:flutter/material.dart';
import 'package:mobile_programming_final_project/view/expenseTracker/ExpenseTrackerHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        "/":(context)=>const MyHomePage(title: 'Team One Final project'),
  "/expense":(context)=>const Expensetrackerhome(),
      } ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
        OutlinedButton(onPressed: (){}, child: Text("Page 1")),
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
