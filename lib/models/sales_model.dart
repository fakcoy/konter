class Sales {
  final String id;
  final String buyer;
  final String phone;
  final String date;
  final String status;
  final String issuer;

  Sales(
      {required this.id,
      required this.buyer,
      required this.phone,
      required this.date,
      required this.status,
      required this.issuer});

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
        id: json['id'],
        buyer: json['buyer'],
        phone: json['phone'],
        date: json['date'],
        status: json['status'],
        issuer: json['issuer']);
  }
}
