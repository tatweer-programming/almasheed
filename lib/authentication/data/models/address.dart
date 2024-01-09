class Address {
  final String street;
  final String city;

  final String type;
  final int houseNumber;
  final int floor;
  final int apartmentNumber;
  final String area;
  final String plot;
  final String avenue;

  Address(
      {required this.street,
      required this.city,
      required this.houseNumber,
      required this.floor,
      required this.apartmentNumber,
      required this.area,
      required this.plot,
      required this.avenue,
      required this.type});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        street: json['street'],
        city: json['city'],
        houseNumber: json['houseNumber'],
        floor: json['floor'],
        apartmentNumber: json['apartmentNumber'],
        area: json['area'],
        plot: json['plot'],
        avenue: json['avenue'],
        type: json['addressType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'houseNumber': houseNumber,
      'floor': floor,
      'apartmentNumber': apartmentNumber,
      'area': area,
      'plot': plot,
      'avenue': avenue,
      'addressType': type
    };
  }
}
