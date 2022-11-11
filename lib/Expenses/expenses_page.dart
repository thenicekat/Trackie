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

  List<int> month = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int monthDropDownValue = DateTime.now().month;

  List<int> year = [2021, 2022, 2023, 2024];
  int yearDropDownValue = DateTime.now().year;

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
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Month"),
                        ),
                        DropdownButton<int>(
                          value: monthDropDownValue,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          items: month.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? chosen) {
                            setState(() {
                              monthDropDownValue = chosen!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Year"),
                        ),
                        DropdownButton<int>(
                          value: yearDropDownValue,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          items: year.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? chosen) {
                            setState(() {
                              yearDropDownValue = chosen!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Query(
                  options: QueryOptions(
                      document: gql(_getMonthlyExpensesQuery),
                      variables: {
                        'month': monthDropDownValue,
                        'year': yearDropDownValue
                      }),
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

                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
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
                      ),
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
