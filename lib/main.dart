import 'package:flutter/material.dart';
import 'package:trackie/CGPA/subjects_page.dart';
import 'package:trackie/Evaluatives/eval_page.dart';
import 'package:trackie/Expenses/expenses_page.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Create an index to keep track of which page we are in
  int currentIndex = 0;

  //Make a list of widgets
  List<Widget> pages = const [
    ExpensesPage(),
    EvalPage(),
    SubjectsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 50, bottom: 0),
          child: pages[currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: 'Expenses',
              icon: Icon(Icons.money),
            ),
            BottomNavigationBarItem(
              label: 'Evals',
              icon: Icon(Icons.book),
            ),
            BottomNavigationBarItem(
              label: 'CGPA',
              icon: Icon(Icons.numbers),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
