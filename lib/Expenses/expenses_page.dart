import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trackie/Expenses/add_an_expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final String _getMonthlyExpensesQuery = """
  query GetExpensesPerMonth(\$year: Float!, \$month: Float!) {
  getExpensesPerMonth(year: \$year, month: \$month) {
    date
    id
    itemName
    place
    price
    quantity
    totalPaid
  }
}""";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Scaffold(
          body: Column(
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
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "-1000₹",
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Query(
                  options: QueryOptions(
                      document: gql(_getMonthlyExpensesQuery),
                      variables: const {'month': 11, 'year': 2022}),
                  builder: (QueryResult? result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    debugPrint(result.toString());

                    if (result!.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result!.isLoading) {
                      return const CircularProgressIndicator(
                          color: Colors.black,
                        );
                    }

                    List expenses = result!.data!['getExpensesPerMonth'];

                    return SizedBox(
                      height: 400,
                      child: Table(
                          border:
                              TableBorder.all(width: 1.0, color: Colors.black),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TableCell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const <Widget>[
                                      Text(
                                        "ID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Name",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Place",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Price",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Quantity",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Total Paid",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            for (var expense in expenses)
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(expense["id"].toString()),
                                        Text(expense["itemName"].toString()),
                                        Text(expense["place"].toString()),
                                        Text(expense["price"].toString()),
                                        Text(expense["quantity"].toString()),
                                        Text(expense["totalPaid"].toString())
                                      ],
                                    ),
                                  ),
                                ),
                              ])
                          ]),
                    );
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const AddExpense();
                }),
              );
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
