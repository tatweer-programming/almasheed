class PorductCustomProperties {
  final Map<String, List<String>> properties;

  // example: {'color': ['red', 'blue', 'green'], 'size': ['small', 'medium', 'large'] , 'weight': ['1kg', '2kg', '3kg']}
  List<String> availableProperties;

  // example : ['red-small-1kg', 'red-small-2kg', 'red-small-3kg', 'red-medium-1kg', 'red-medium-2kg', 'green-small-2kg']

  PorductCustomProperties(
      {required this.properties, required this.availableProperties});

  List<String> searchinAvailablePropsfromChoosenProps(
      List<String> choosenProps) {
    // example for chosen props : ['red', '1kg']
    // rerurn Strings that contains all choosenProps in the same String
    return availableProperties
        .where(
            (element) => choosenProps.every((prop) => element.contains(prop)))
        .toList();
  }

  // fromJson and toJson
  factory PorductCustomProperties.fromJson(Map<String, dynamic> json) {
    return PorductCustomProperties(
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

// example for custom properties
