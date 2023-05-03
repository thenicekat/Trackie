import 'package:flutter/material.dart';

class AddASubject extends StatefulWidget {
  AddASubject({Key? key}) : super(key: key);

  String dept = "", code = "", sem = "";
  int credits = 0, midsemGrade = 0, finalGrade = 0;

  AddASubject.withData({
    Key? key,
    required this.dept,
    required this.code,
    required this.credits,
    required this.sem,
    required this.midsemGrade,
    required this.finalGrade,
  }) : super(key: key);

  @override
  State<AddASubject> createState() => _AddASubjectState();
}

class _AddASubjectState extends State<AddASubject> {
  TextEditingController dept = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController credits = TextEditingController();
  TextEditingController sem = TextEditingController();
  TextEditingController midsemGrade = TextEditingController();
  TextEditingController finalGrade = TextEditingController();

  bool isLoading = false;
  bool isLoadingDelete = false;

  @override
  void initState() {
    dept.text = "";
    code.text = "";
    credits.text = "";
    sem.text = "";
    midsemGrade.text = "";
    finalGrade.text = "";

    if (widget.dept != "") {
      dept.text = widget.dept;
    }

    if (widget.code != "") {
      code.text = widget.code;
    }

    if (widget.sem != "") {
      sem.text = widget.sem;
    }

    if (widget.credits.toString() != "") {
      credits.text = widget.credits.toString();
    }

    if (widget.midsemGrade.toString() != "") {
      midsemGrade.text = widget.midsemGrade.toString();
    }

    if (widget.finalGrade.toString() != "") {
      finalGrade.text = widget.finalGrade.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Subject"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: dept,
                  decoration: const InputDecoration(
                    labelText: "Department", //babel text
                    prefixIcon: Icon(Icons.apartment_rounded), //prefix icon
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300), //hint text style
                    labelStyle: TextStyle(
                        fontSize: 13, color: Colors.black), //label style
                  )),

              Container(height: 20), //space between text field

              TextField(
                  controller: code,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.abc_rounded),
                    labelText: "Subject Code",
                    hintStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                  )),

              Container(height: 20),

              TextField(
                  controller: credits,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.check),
                    labelText: "Credits",
                    hintStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                  )),

              Container(height: 20),

              TextField(
                  controller: sem,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers_outlined),
                    labelText: "Semester",
                    hintStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                  )),

              Container(height: 20),

              TextField(
                  controller: midsemGrade,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grade),
                    labelText: "Midsem Grade",
                    hintStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                  )),

              Container(height: 20),

              TextField(
                  controller: finalGrade,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grade_outlined),
                    labelText: "Final Grade",
                    hintStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                  )),

              Container(height: 20),

              SizedBox(
                width: 130,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    try {

                    } on FormatException {
                      const snackBar = SnackBar(
                        content: Text('Fill in all the fields'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
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
      ),
    );
  }
}