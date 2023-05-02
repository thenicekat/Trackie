import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trackie/Models/ExpenseModel.dart';
import 'package:trackie/Providers/ExpenseProvider.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController place = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController itemName = TextEditingController();
  bool isLoading = false;
  late ExpenseProvider _expenseProvider;

  @override
  void initState() {
    place.text = "";
    price.text = "";
    quantity.text = "";
    itemName.text = "";
    super.initState();
    this._expenseProvider = ExpenseProvider();
    this._expenseProvider.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add an Expense"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: place,
                decoration: const InputDecoration(
                  labelText: "Place", //babel text
                  hintText: "Where did you buy?", //hint text
                  prefixIcon: Icon(Icons.place), //prefix icon
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300), //hint text style
                  labelStyle: TextStyle(
                      fontSize: 13, color: Colors.black), //label style
                )),

            Container(height: 20), //space between text field

            TextField(
                controller: itemName,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.abc_rounded),
                  labelText: "Item Name",
                  hintText: "What did you buy?",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                )),

            Container(height: 30),

            TextField(
                controller: price,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.currency_rupee),
                  labelText: "Total Money Spent",
                  hintText: "How much did you Spend?",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                )),

            Container(height: 30),

            SizedBox(
              width: 130,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    ExpenseModel expenseModel = ExpenseModel(place: place.text, itemName: itemName.text, moneySpent: int.parse(price.text));
                    int result = await _expenseProvider.addExpense(expenseModel);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context, result != null);
                  } on FormatException {
                    const snackBar = SnackBar(
                      content: Text('Fill in all the fields'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ])
                    : const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
