import 'package:flutter/material.dart';
import 'package:trackie/Expenses/add_an_expense.dart';
import 'package:trackie/Providers/DatabaseProvider.dart';
import 'package:trackie/Models/ExpenseModel.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late DatabaseProvider _databaseProvider;
  int totalSpent = 0;
  bool isLoading = false;
  bool isLoadingReset = false;
  List<ExpenseModel> _expenses = [];

  void _refreshExpenses() async {
    final data = await _databaseProvider.retrieveExpenses();
    final sum = await _databaseProvider.getTotalSpent();
    setState(() {
      _expenses = data;
      totalSpent = -sum;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _databaseProvider = DatabaseProvider();
    _databaseProvider.initializeDB().whenComplete(() async {
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
                            child: Column(
                              children: [
                                for (var expense in _expenses)
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.money),
                                          title: Text(
                                            expense.itemName.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            expense.moneySpent.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20),
                                          ),
                                          onLongPress: () async {
                                            final addExpenseBool =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                                return AddExpense.withData(
                                                  id: expense.id as int,
                                                  itemName: expense.itemName
                                                      as String,
                                                  moneySpent: expense.moneySpent
                                                      .toString(),
                                                );
                                              }),
                                            );

                                            if (addExpenseBool) {
                                              _refreshExpenses();
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Datetime: ${DateTime.fromMillisecondsSinceEpoch(expense.datetime).toLocal().toString().split(".")[0]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              child: const Text('DELETE'),
                                              onPressed: () async {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                try {
                                                  _databaseProvider
                                                      .deleteExpense(
                                                          expense.id as int);
                                                  _refreshExpenses();
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                } on Exception {
                                                  const snackBar = SnackBar(
                                                    content: Text(
                                                        'Error deleting expense'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
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
                            _databaseProvider.truncateExpenses();
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
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
