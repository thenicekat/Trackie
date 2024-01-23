import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackie/CGPA/add_a_subject.dart';
import 'package:trackie/Models/SubjectModel.dart';
import 'package:trackie/Providers/SubjectProvider.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  String? semDropDownValue = "3-2";
  List<SubjectModel> subjects = [];
  bool isLoading = false;
  late SubjectProvider _subjectProvider;

  void addSemToPref(String semester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sem', semester);
  }

  void getSemFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? semester = prefs.getString('sem');
    setState(() {
      if (semester != null) semDropDownValue = semester;
    });
  }

  void _refreshSubjects() async {
    final data = await _subjectProvider.retrieveSubjects(semDropDownValue!);
    debugPrint(semDropDownValue!);
    debugPrint(data.toString());
    setState(() {
      subjects = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _subjectProvider = SubjectProvider();
    _subjectProvider.initializeDB().whenComplete(() async {
      _refreshSubjects();
      setState(() {
        isLoading = true;
      });
    });
  }

  List<String> sem = [
    "1-1",
    "1-2",
    "2-1",
    "2-2",
    "PS-I",
    "3-1",
    "3-2",
    "PS-II",
    "4-2"
  ];

  @override
  Widget build(BuildContext context) {
    getSemFromPref();

    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SGPA: 6.9',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Midsem SGPA: 6.9',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Semester",
                style: TextStyle(fontSize: 30),
              ),
            ),
            DropdownButton<String>(
              value: semDropDownValue,
              elevation: 16,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              items: sem.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? chosen) {
                setState(() {
                  semDropDownValue = chosen!;
                  addSemToPref(chosen);
                });
              },
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(top: 4),
            child: FittedBox(
              child: SingleChildScrollView(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                            CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ])
                    : DataTable(
                        showCheckboxColumn: false,
                        columnSpacing: 10.0,
                        columns: const [
                            DataColumn(
                              label: Text(
                                "Subject",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Credits",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Midsem Grade",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Final Grade",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        rows: [
                            // for (var subject in subjects)
                            //   DataRow(
                            //       cells: [
                            //         DataCell(Text(subject["dept"].toString())),
                            //         DataCell(Text(subject["code"].toString())),
                            //         DataCell(Text(subject["credits"].toString())),
                            //         DataCell(
                            //             Text(subject["midsemGrade"].toString())),
                            //         DataCell(
                            //             Text(subject["finalGrade"].toString())),
                            //       ],
                            //       onSelectChanged: (value) {
                            //         debugPrint(subject.toString());
                            //         Navigator.of(context).push(
                            //           MaterialPageRoute(
                            //               builder: (BuildContext context) {
                            //                 return AddASubject.withData(
                            //                   dept: subject["dept"],
                            //                   code: subject["code"],
                            //                   credits: subject["credits"],
                            //                   sem: subject["sem"],
                            //                   midsemGrade: subject["midsemGrade"],
                            //                   finalGrade: subject["finalGrade"],
                            //                 );
                            //               }),
                            //         );
                            //       }),
                          ]),
              ),
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return AddASubject();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
