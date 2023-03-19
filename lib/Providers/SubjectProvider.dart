import 'package:sqflite/sqflite.dart';
import 'package:trackie/Models/Subject.dart';

class SubjectProvider {
  late Database db;

  Future open(String path) async{
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        '''
        create table subjects (
        id integer primary key autoincrement, 
        dept text not null,
        code text not null,
        credits integer not null,
        midsemGrade integer not null,
        finalGrade integer not null)
        '''
      );
    });
  }

  Future<Subject> addSubject(Subject subject) async {
    await db.insert("subjects", subject.toMap());
    return subject;
  }


}