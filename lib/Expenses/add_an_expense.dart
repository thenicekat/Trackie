import 'package:flutter/material.dart';
import 'package:trackie/Models/ExpenseModel.dart';
import 'package:trackie/Providers/DatabaseProvider.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense({Key? key}) : super(key: key);

  int id = 0;
  String itemName = "";
  String moneySpent = "";

  AddExpense.withData(
      {Key? key,
      required this.id,
      required this.itemName,
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
  late DatabaseProvider _databaseProvider;

  @override
  void initState() {
    place.text = "";
    price.text = "";
    itemName.text = "";

    if (widget.id != 0) {
      price.text = widget.moneySpent;
      itemName.text = widget.itemName;
    }

    super.initState();
    _databaseProvider = DatabaseProvider();
    _databaseProvider.initializeDB().whenComplete(() async {
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
            Container(height: 20), //space between text field

            TextField(
                controller: itemName,
                textCapitalization: TextCapitalization.words,
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
                          itemName: itemName.text.trim(),
                          moneySpent: int.parse(price.text),
                          datetime: DateTime.now().millisecondsSinceEpoch);
                      result = await _databaseProvider.addExpense(expenseModel);
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      ExpenseModel expenseModel = ExpenseModel(
                          id: widget.id,
                          itemName: itemName.text.trim(),
                          moneySpent: int.parse(price.text),
                          datetime: DateTime.now().millisecondsSinceEpoch);
                      result = await _databaseProvider.addExpense(expenseModel);
                      setState(() {
                        isLoading = false;
                      });
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  } on FormatException {
                    const snackBar = SnackBar(
                      content: Text('Fill in all the fields'),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                      if (widget.id == 0) {
                      } else {
                        _databaseProvider.deleteExpense(widget.id);
                        setState(() {
                          isLoadingDelete = false;
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
                  child: isLoadingDelete
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
