import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trackie/Models/ExpenseModel.dart';
import 'package:trackie/Providers/ExpenseProvider.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key? key}) : super(key: key);

  int id = 0;
  String itemName = "";
  String place = "";
  String moneySpent = "";

  AddExpense.withData(
      {Key? key,
      required this.id,
      required this.itemName,
      required this.place,
      required this.moneySpent})
      : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController place = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController itemName = TextEditingController();
  bool isLoading = false;
  bool isLoadingDelete = false;
  late ExpenseProvider _expenseProvider;

  @override
  void initState() {
    place.text = "";
    price.text = "";
    itemName.text = "";

    if (widget.id != 0) {
      place.text = widget.place;
      price.text = widget.moneySpent;
      itemName.text = widget.itemName;
    }

    super.initState();
    _expenseProvider = ExpenseProvider();
    _expenseProvider.initializeDB().whenComplete(() async {
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
                keyboardType: const TextInputType.numberWithOptions(),
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
                    int result;
                    if (widget.id == 0) {
                      ExpenseModel expenseModel = ExpenseModel(
                          place: place.text,
                          itemName: itemName.text,
                          moneySpent: int.parse(price.text));
                      result = await _expenseProvider.addExpense(expenseModel);
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      ExpenseModel expenseModel = ExpenseModel(
                          id: widget.id,
                          place: place.text,
                          itemName: itemName.text,
                          moneySpent: int.parse(price.text));
                      result = await _expenseProvider.addExpense(expenseModel);
                      setState(() {
                        isLoading = false;
                      });
                    }

                    Navigator.pop(context, true);
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
                      isLoadingDelete = true;
                    });
                    try {
                      if (widget.id == 0) {}
                      else{
                        _expenseProvider.deleteExpense(widget.id);
                        setState(() {
                          isLoadingDelete = false;
                        });
                      }

                      Navigator.pop(context, true);
                    } on FormatException {
                      const snackBar = SnackBar(
                        content: Text('Fill in all the fields'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }
                  },
                  child: isLoadingDelete
                      ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ])
                      : const Text('Delete'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
