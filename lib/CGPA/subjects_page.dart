import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackie/CGPA/add_a_subject.dart';
import 'package:trackie/Models/SubjectModel.dart';
import 'package:trackie/Providers/DatabaseProvider.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  String? semDropDownValue = "3-2";
  List<SubjectModel> subjects = [];
  bool isLoading = false;
  late DatabaseProvider _databaseProvider;
  int cgpa = 0;
  int sgpa = 0;

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
    final data = await _databaseProvider.retrieveSubjects(semDropDownValue!);
    debugPrint(semDropDownValue!);
    setState(() {
      subjects = data;
      isLoading = false;
    });

    final cgpaData = await _databaseProvider.findCGPA();
    final sgpaData = await _databaseProvider.findSGPA(semDropDownValue!);
    setState(() {
      sgpa = sgpaData;
      cgpa = cgpaData;
    });
  }

  @override
  void initState() {
    super.initState();
    _databaseProvider = DatabaseProvider();
    _databaseProvider.initializeDB().whenComplete(() async {
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
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        'CGPA: $cgpa',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'SGPA: $sgpa',
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
                  _refreshSubjects();
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
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Credits",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Grade",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        rows: [
                            for (var subject in subjects)
                              DataRow(
                                  cells: [
                                    DataCell(Text(
                                      subject.subject.toString(),
                                      style: const TextStyle(fontSize: 24),
                                    )),
                                    DataCell(Text(
                                      subject.credits.toString(),
                                      style: const TextStyle(fontSize: 24),
                                    )),
                                    DataCell(Text(
                                      subject.grade.toString(),
                                      style: const TextStyle(fontSize: 24),
                                    )),
                                  ],
                                  onSelectChanged: (value) {
                                    debugPrint(subject.toString());
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return AddASubject.withData(
                                          subject: subject.subject,
                                          credits: subject.credits,
                                          sem: subject.sem,
                                          grade: subject.grade,
                                        );
                                      }),
                                    );
                                  }),
                          ]),
              ),
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final addSubjectBool = await Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return AddASubject();
            }),
          );

          if (addSubjectBool) {
            _refreshSubjects();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
