// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trackie/Academics/academic_page.dart';
import 'package:trackie/Expenses/expenses_page.dart';
import 'constants.dart' as Constants;

void main() {
  final HttpLink httpLink =
      HttpLink("https://trackie-api-production.up.railway.app/graphql");

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    ),
  );

  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatefulWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Create an index to keep track of which page we are in
  int currentIndex = 0;

  //Make a list of widgets
  List<Widget> pages = const [
    AcademicsPage(),
    ExpensesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Constants.shouldUseGraphQL
        ? GraphQLProvider(
            client: widget.client,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blueGrey,
              ),
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(
                      right: 16, left: 16, top: 50, bottom: 0),
                  child: pages[currentIndex],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      label: 'Academics',
                      icon: Icon(Icons.book),
                    ),
                    BottomNavigationBarItem(
                      label: 'Expenses',
                      icon: Icon(Icons.money),
                    ),
                  ],
                  currentIndex: currentIndex,
                  onTap: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, top: 50, bottom: 0),
                child: pages[currentIndex],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    label: 'Academics',
                    icon: Icon(Icons.book),
                  ),
                  BottomNavigationBarItem(
                    label: 'Expenses',
                    icon: Icon(Icons.money),
                  ),
                ],
                currentIndex: currentIndex,
                onTap: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          );
  }
}
