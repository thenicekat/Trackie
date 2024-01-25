class ExpenseModel {
  int? id;
  String? itemName;
  final int moneySpent;
  final int datetime;

  ExpenseModel(
      {this.id,
      this.itemName,
      required this.moneySpent,
      required this.datetime});

  ExpenseModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        itemName = item["itemName"],
        moneySpent = item["moneySpent"],
        datetime = item["datetime"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'moneySpent': moneySpent,
      'datetime': datetime
    };
  }
}
