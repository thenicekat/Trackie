import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackie/Academics/add_a_subject.dart';
import '../constants.dart' as constants;

class AcademicsPage extends StatefulWidget {
  const AcademicsPage({Key? key}) : super(key: key);

  @override
  State<AcademicsPage> createState() => _AcademicsPageState();
}

class _AcademicsPageState extends State<AcademicsPage> {
  String? semDropDownValue = "2-1";

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

  final String _getSGPA = """
  query GetSGPA(\$sem: String!) {
    getSGPA(
        sem: \$sem
    ){
        midsemSG,
        finalSG
    }
  }""";

  final String _getSubjectsPerSem = """
  query GetSubjectsPerSem(\$sem: String!) {
    getSubjectsPerSem(
        sem: \$sem
    ){
        id
        dept
        code
        sem
        credits
        midsemGrade
        finalGrade
    }
  }""";

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

  void _showSnackBar(String message) {
    var snackBar = const SnackBar(
      content: Text("Server Error"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                  child: Query(
                      options: QueryOptions(
                        document: gql(_getSGPA),
                        variables: {"sem": semDropDownValue},
                        fetchPolicy: FetchPolicy.cacheAndNetwork,
                      ),
                      builder: (QueryResult? result,
                          {VoidCallback? refetch, FetchMore? fetchMore}) {
                        debugPrint(result.toString());

                        if (result!.hasException) {
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              _showSnackBar(result.exception.toString()));
                          return const Text("");
                        }

                        if (result!.isLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.black,
                          );
                        }

                        double sgpa = double.parse((result.data?["getSGPA"]
                                ["finalSG"])
                            .toStringAsFixed(2));
                        double midsgpa = double.parse((result.data?["getSGPA"]
                                ["midsemSG"])
                            .toStringAsFixed(2));

                        return Column(
                          children: [
                            Text(
                              'SGPA: $sgpa',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Midsem SGPA: $midsgpa',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        );
                      }),
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
        Query(
          options: QueryOptions(
            document: gql(_getSubjectsPerSem),
            variables: {"sem": semDropDownValue},
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: ((result, {fetchMore, refetch}) {
            debugPrint(result.toString());

            if (result!.hasException) {
              const snackBar = SnackBar(
                content: Text('Server Error'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return Text(result.exception.toString());
            }

            if (result!.isLoading) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            }

            List subjects = result!.data!['getSubjectsPerSem'];

            return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FittedBox(
                  child: SingleChildScrollView(
                    child: DataTable(
                        showCheckboxColumn: false,
                        columnSpacing: 10.0,
                        columns: const [
                          DataColumn(
                            label: Text(
                              "Department",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Code",
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
                          for (var subject in subjects)
                            DataRow(
                                cells: [
                                  DataCell(Text(subject["dept"].toString())),
                                  DataCell(Text(subject["code"].toString())),
                                  DataCell(Text(subject["credits"].toString())),
                                  DataCell(
                                      Text(subject["midsemGrade"].toString())),
                                  DataCell(
                                      Text(subject["finalGrade"].toString())),
                                ],
                                onSelectChanged: (value) {
                                  debugPrint(subject.toString());
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return AddASubject.withData(
                                        dept: subject["dept"],
                                        code: subject["code"],
                                        credits: subject["credits"],
                                        sem: subject["sem"],
                                        midsemGrade: subject["midsemGrade"],
                                        finalGrade: subject["finalGrade"],
                                      );
                                    }),
                                  );
                                }),
                        ]),
                  ),
                ));
          }),
        )
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
