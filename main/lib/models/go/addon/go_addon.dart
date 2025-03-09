import 'package:smart/smart.dart';

import 'go_addon_plan.dart';

class GoAddon {
  GoAddon({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.plans,
  });

  final int id;
  final String name;
  final String description;
  final String type;
  final List<GoAddonPlan> plans;

  GoAddon copyWith({
    int? id,
    String? name,
    String? description,
    String? type,
    List<GoAddonPlan>? plans,
  }) {
    return GoAddon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      plans: plans ?? this.plans,
    );
  }

  factory GoAddon.fromJson(Map<String, dynamic> json){
    return GoAddon(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      type: json["type"] ?? "",
      plans: json["plans"] == null
          ? []
          : List<GoAddonPlan>.from(json["plans"]!.map((x) => GoAddonPlan.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "plans": plans.map((x) => x.toJson()).toList(),
  };

  bool get isAd => type.equalsIgnoreCase("advertisement") || type.startsWith("advert");

  @override
  String toString(){
    return "$id, $name, $description, $type, $plans, ";
  }
}