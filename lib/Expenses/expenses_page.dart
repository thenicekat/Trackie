import 'package:flutter/material.dart';
import 'package:trackie/Expenses/add_an_expense.dart';
import 'package:trackie/Providers/ExpenseProvider.dart';
import 'package:trackie/Models/ExpenseModel.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late ExpenseProvider _expenseProvider;
  int totalSpent = 0;
  bool isLoading = false;
  List<ExpenseModel> _expenses = [];

  void _refreshExpenses() async {
    final data = await _expenseProvider.retrieveExpenses();
    final sum = await _expenseProvider.getTotalSpent();
    setState(() {
      _expenses = data;
      totalSpent = sum;
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
          body: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 150,
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
                          child: isLoading ? CircularProgressIndicator(
                            color: Colors.white,
                          ) : Text(
                            "-$totalSpent₹",
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
                        height: 400,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "ID",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Place",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Total Paid",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                            rows: [
                              for (var expense in _expenses)
                                DataRow(cells: [
                                  DataCell(Text(expense.id.toString())),
                                  DataCell(
                                      Text(expense.itemName.toString())),
                                  DataCell(Text(expense.place.toString())),
                                  DataCell(
                                      Text(expense.moneySpent.toString())),
                                ])
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              final addExpenseBool = await Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const AddExpense();
                }),
              );

              if (addExpenseBool) {
                _refreshExpenses();
                setState(() {});
              }
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
