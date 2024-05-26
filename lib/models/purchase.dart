class Purchase {
  int id = 0;
  String name = "";
  int price = 0;
  int quantity = 0;

  Purchase({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Purchase.fromMap(Map<String, dynamic> purchase) {
    id = purchase["id"];
    name = purchase["name"];
    price = purchase["price"];
    quantity = purchase["quantity"];
  }
}
