class Rating {
  final double rate;
  final String customerId;

  Rating({
    required this.rate,
    required this.customerId,
  });
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'customerId': customerId,
    };
  }
}
