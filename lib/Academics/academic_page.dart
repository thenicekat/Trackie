import 'package:flutter/material.dart';

class AcademicsPage extends StatelessWidget {
  const AcademicsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                color: Colors.black,),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "CGPA: 8.00",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
