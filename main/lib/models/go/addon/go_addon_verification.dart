import 'go_addon_plan.dart';

class GoAddonVerification {
  GoAddonVerification({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.plans,
    required this.activator
  });

  final int id;
  final String name;
  final String description;
  final String type;
  final GoAddonPlan activator;
  final List<GoAddonPlan> plans;

  GoAddonVerification copyWith({
    int? id,
    String? name,
    String? description,
    String? type,
    GoAddonPlan? activator,
    List<GoAddonPlan>? plans,
  }) {
    return GoAddonVerification(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      plans: plans ?? this.plans,
      activator: activator ?? this.activator,
    );
  }

  factory GoAddonVerification.fromJson(Map<String, dynamic> json){
    return GoAddonVerification(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      type: json["type"] ?? "",
      activator: GoAddonPlan.fromJson(json["activator"]),
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
    "activator": activator.toJson(),
    "plans": plans.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $name, $description, $type, $plans, $activator";
  }
}