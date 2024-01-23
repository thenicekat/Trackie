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
  bool isLoadingReset = false;
  List<ExpenseModel> _expenses = [];

  void _refreshExpenses() async {
    final data = await _expenseProvider.retrieveExpenses();
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: DataTable(
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "Item Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Amount",
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
                                          expense.itemName.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                        DataCell(Text(
                                          expense.moneySpent.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                      ],
                                      onSelectChanged: (value) async {
                                        final addExpenseBool =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                            return AddExpense.withData(
                                              id: expense.id as int,
                                              itemName:
                                                  expense.itemName as String,
                                              moneySpent:
                                                  expense.moneySpent.toString(),
                                            );
                                          }),
                                        );

                                        if (addExpenseBool) {
                                          _refreshExpenses();
                                          setState(() {});
                                        }
                                      })
                              ],
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 130,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(),
                        onPressed: () {
                          setState(() {
                            isLoadingReset = true;
                          });
                          try {
                            _expenseProvider.truncateExpenses();
                            _refreshExpenses();
                            setState(() {
                              isLoadingReset = false;
                            });
                          } on FormatException {
                            const snackBar = SnackBar(
                              content: Text('Fill in all the fields'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: isLoadingReset
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ])
                            : const Text('Reset'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              final addExpenseBool = await Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return AddExpense();
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
