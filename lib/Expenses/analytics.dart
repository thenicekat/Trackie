import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackie/Expenses/add_an_expense.dart';
import 'package:trackie/Models/ExpenseModel.dart';
import 'package:trackie/Providers/ExpenseProvider.dart';

class ExpenseAnalytics extends StatefulWidget {
  const ExpenseAnalytics({Key? key}) : super(key: key);

  @override
  State<ExpenseAnalytics> createState() => _ExpenseAnalyticsState();
}

class _ExpenseAnalyticsState extends State<ExpenseAnalytics> {
  late ExpenseProvider _expenseProvider;
  int totalSpent = 0;
  bool isLoading = false;
  List<ExpenseModel> _expenses = [];

  void _refreshExpenses() async {
    final data = await _expenseProvider.retrieveExpenseAnalytics();
    final sum = await _expenseProvider.getTotalSpent();
    setState(() {
      _expenses = data;
      totalSpent = -sum;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _expenseProvider = ExpenseProvider();
    _expenseProvider.initializeDB().whenComplete(() async {
      _refreshExpenses();
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          width: 300,
                          height: MediaQuery.of(context).size.height * 0.175,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "$totalSpent₹",
                                      style: const TextStyle(
                                        fontSize: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: DataTable(
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "Place",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Total Paid",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                              rows: [
                                for (var expense in _expenses)
                                  DataRow(
                                    cells: [
                                      DataCell(Text(
                                        expense.place.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                        expense.moneySpent.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
