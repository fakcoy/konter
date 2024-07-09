class Stock {
  final String id;
  final String name;
  final int qty;
  final String attr;
  final num weight;
  final String issuer;

  Stock(
      {required this.id,
      required this.name,
      required this.qty,
      required this.attr,
      required this.weight,
      required this.issuer});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        id: json['id'],
        name: json['name'],
        qty: (json['qty'] as num).toInt(),
        attr: json['attr'],
        weight: json['weight'],
        issuer: json['issuer']);
  }
}
