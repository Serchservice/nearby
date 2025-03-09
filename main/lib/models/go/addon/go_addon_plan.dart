class GoAddonPlan {
  GoAddonPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.interval,
    required this.currency,
  });

  final String id;
  final String name;
  final String description;
  final String amount;
  final String interval;
  final String currency;

  GoAddonPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? amount,
    String? interval,
    String? currency,
  }) {
    return GoAddonPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      interval: interval ?? this.interval,
      currency: currency ?? this.currency,
    );
  }

  factory GoAddonPlan.fromJson(Map<String, dynamic> json){
    return GoAddonPlan(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      amount: json["amount"] ?? "",
      interval: json["interval"] ?? "",
      currency: json["currency"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "amount": amount,
    "interval": interval,
    "currency": currency,
  };

  @override
  String toString(){
    return "$id, $name, $description, $amount, $interval, $currency, ";
  }
}