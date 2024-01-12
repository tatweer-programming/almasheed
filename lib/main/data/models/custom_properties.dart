class ProductCustomProperties {
  final Map<String, List<String>> properties;

  // example: {'color': ['red', 'blue', 'green'], 'size': ['small', 'medium', 'large'] , 'weight': ['1kg', '2kg', '3kg']}
  List<String> availableProperties;

  // example : ['red-small-1kg', 'red-small-2kg', 'red-small-3kg', 'red-medium-1kg', 'red-medium-2kg', 'green-small-2kg']

  ProductCustomProperties(
      {required this.properties, required this.availableProperties});

  // هتبحث بيها لما يختار اي عنصر وهترجعلك الخيارات المتاحة من العنصر بتاعه
  List<String> searchInAvailablePropsFromChosenProps(
      List<String> chosenProps) {
    // example for chosen props : ['red', '1kg']
    // return Strings that contains all chosenProps in the same String
    return availableProperties
        .where(
            (element) => chosenProps.every((prop) => element.contains(prop)))
        .toList();
  }

  // fromJson and toJson ya 3am kman aho
  // 7bebeeee
  factory ProductCustomProperties.fromJson(Map<String, dynamic> json) {
    return ProductCustomProperties(
      properties: json['properties'],
      availableProperties: json['availableProperties'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'properties': properties,
      'availableProperties': availableProperties,
    };
  }
}
