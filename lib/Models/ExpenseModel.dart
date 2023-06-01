class ExpenseModel {
  int? id;
  final String place;
  String? itemName;
  final int moneySpent;

  ExpenseModel({
    this.id,
    required this.place,
    this.itemName,
    required this.moneySpent
  });

  ExpenseModel.fromMap(Map<String, dynamic> item):
        id = item["id"], place = item["place"], itemName = item["itemName"], moneySpent = item["moneySpent"];

  ExpenseModel.fromMapWithoutPlace(Map<String, dynamic> item):
        id = item["id"], place = item["place"], moneySpent = item["sum(moneySpent)"];

  Map<String, Object?> toMap(){
    return {'id': id, 'place': place, 'itemName': itemName, 'moneySpent': moneySpent};
  }
}