import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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

  final String _addExpenseMutation = """
  mutation AddNewExpense(\$place: String!, \$itemName: String!, \$price: Float!, \$quantity: Float!) {
    addNewExpense(
        place: \$place,
        itemName: \$itemName,
        price: \$price,
        quantity: \$quantity
    ) {
        id,
        date,
        place,
        itemName,
        price,
        quantity,
        totalPaid
    }
}""";

  @override
  void initState() {
    place.text = "";
    price.text = "";
    quantity.text = "";
    itemName.text = "";
    super.initState();
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
                controller: price,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.currency_rupee),
                  labelText: "Price",
                  hintText: "Price per Item",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                )),

            Container(height: 20), //space between text field

            TextField(
                controller: quantity,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  labelText: "Quantity",
                  hintText: "How many did you buy?",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                )),

            Container(height: 20), //space between text field

            TextField(
              controller: itemName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                labelText: "Name",
                hintText: "What did you buy?",
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                labelStyle: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),

            Container(height: 30),

            SizedBox(
              width: 130,
              height: 50,
              child: Mutation(
                  options: MutationOptions(
                      document: gql(_addExpenseMutation),
                      onCompleted: (dynamic data) {
                        debugPrint(data.toString());
                          if(data?["addNewExpense"] != null){
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          }
                      }),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          runMutation({
                            "place": place.text,
                            "price": int.parse(price.text),
                            "quantity": int.parse(quantity.text),
                            "itemName": itemName.text
                          });
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
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
