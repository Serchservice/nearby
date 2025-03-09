class GoUserAddonSwitching {
  GoUserAddonSwitching({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.interval,
    required this.currency,
    required this.startsWhen,
    required this.canCancel,
  });

  final String id;
  final String name;
  final String description;
  final String amount;
  final String interval;
  final String currency;
  final String? startsWhen;
  final bool canCancel;

  GoUserAddonSwitching copyWith({
    String? id,
    String? name,
    String? description,
    String? amount,
    String? interval,
    String? currency,
    String? startsWhen,
    bool? canCancel,
  }) {
    return GoUserAddonSwitching(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      interval: interval ?? this.interval,
      currency: currency ?? this.currency,
      startsWhen: startsWhen ?? this.startsWhen,
      canCancel: canCancel ?? this.canCancel,
    );
  }

  factory GoUserAddonSwitching.fromJson(Map<String, dynamic> json){
    return GoUserAddonSwitching(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      amount: json["amount"] ?? "",
      interval: json["interval"] ?? "",
      currency: json["currency"] ?? "",
      startsWhen: json["starts_when"] ?? "",
      canCancel: json["can_cancel"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "amount": amount,
    "interval": interval,
    "currency": currency,
    "starts_when": startsWhen,
    "can_cancel": canCancel,
  };

  @override
  String toString(){
    return "$id, $name, $description, $amount, $interval, $currency, $startsWhen, $canCancel, ";
  }
}