class EvaluativeModel {
  int? id;
  late String subject;
  late int marksReceieved;
  late int marksTotal;

  EvaluativeModel({
    this.id,
    required this.subject,
    required this.marksReceieved,
    required this.marksTotal
  });
}