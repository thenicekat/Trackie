class ExpenseModel {
  int? id;
  String? itemName;
  final int moneySpent;

  ExpenseModel({
    this.id,
    this.itemName,
    required this.moneySpent
  });

  ExpenseModel.fromMap(Map<String, dynamic> item):
        id = item["id"], itemName = item["itemName"], moneySpent = item["moneySpent"];

  ExpenseModel.fromMapWithoutPlace(Map<String, dynamic> item):
        id = item["id"], moneySpent = item["sum(moneySpent)"];

  Map<String, Object?> toMap(){
    return {'id': id, 'itemName': itemName, 'moneySpent': moneySpent};
  }
}