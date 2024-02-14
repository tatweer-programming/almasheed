class ProductCustomProperties {
  Map<String, List<String>> properties;
  List<String> availableProperties;

  ProductCustomProperties(
      {required this.properties, required this.availableProperties});

  List<String> searchInAvailablePropsFromChosenProps(List<String> chosenProps) {
    List<String> res = [];
    res = availableProperties
        .where((element) => chosenProps.every((prop) => element.contains(prop)))
        .toList();
    if (res.isEmpty) return [];
    return res.first.split('-');
  }

  // fromJson and toJson ya 3am kman aho
  // 7bebeeee
  factory ProductCustomProperties.fromJson(Map<String, dynamic> json) {
    return ProductCustomProperties(
      properties: (json['properties'] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(key, (value as List<dynamic>).cast<String>())),
      availableProperties: List<String>.from(json['availableProperties'])
          .map((prop) => prop)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'properties': properties,
      'availableProperties': availableProperties,
    };
  }
}
