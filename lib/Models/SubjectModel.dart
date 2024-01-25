class SubjectModel {
  int? id;
  late String subject;
  late String sem;
  late int credits;
  late int grade;

  SubjectModel(
      {this.id,
      required this.subject,
      required this.sem,
      required this.credits,
      required this.grade});

  SubjectModel.fromMap(Map<String, dynamic> item) {
    id = item["id"];
    subject = item["subject"];
    sem = item["sem"];
    credits = item["credits"];
    grade = item["grade"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'sem': sem,
      'credits': credits,
      'grade': grade,
    };
  }
}
