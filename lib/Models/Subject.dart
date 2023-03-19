class Subject {
  late String dept;
  late String code;
  late int credits;
  late int midsemGrade;
  late int finalGrade;

  Subject({
    required this.dept,
    required this.code,
    required this.credits,
    required this.midsemGrade,
    required this.finalGrade
  });

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      "dept": dept,
      "code": code,
      "credits": credits,
      "midsemGrade": midsemGrade,
      "finalGrade": finalGrade
    };
    return map;
  }

  Subject.fromMap(Map<String, Object?> map){
    dept = map["dept"] as String;
    code = map["code"] as String;
    credits = map["credits"] as int;
    midsemGrade = map["midsemGrade"] as int;
    finalGrade = map["finalGrade"] as int;
  }
}