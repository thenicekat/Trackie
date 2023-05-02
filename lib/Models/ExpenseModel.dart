class ExpenseModel {
  int? id;
  final String place;
  final String itemName;
  final int moneySpent;

  ExpenseModel({
    this.id,
    required this.place,
    required this.itemName,
    required this.moneySpent
  });

  ExpenseModel.fromMap(Map<String, dynamic> item):
        id = item["id"], place = item["place"], itemName = item["itemName"], moneySpent = item["moneySpent"];

  Map<String, Object?> toMap(){
    return {'id': id, 'place': place, 'itemName': itemName, 'moneySpent': moneySpent};
  }
}