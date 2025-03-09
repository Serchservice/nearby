import 'package:smart/smart.dart';

import 'go_addon.dart';
import 'go_user_addon_constraint.dart';
import 'go_user_addon_timeline.dart';
import 'go_user_addon_switching.dart';
import 'go_credit_card.dart';

class GoUserAddon {
  GoUserAddon({
    required this.id,
    required this.name,
    required this.description,
    required this.interval,
    required this.status,
    required this.amount,
    required this.recurring,
    required this.constraint,
    required this.timeline,
    required this.switching,
    required this.card,
    required this.addon,
  });

  final int id;
  final String name;
  final String description;
  final String interval;
  final String status;
  final String amount;
  final bool recurring;
  final GoUserAddonConstraint constraint;
  final GoUserAddonTimeline timeline;
  final GoUserAddonSwitching? switching;
  final GoCreditCard card;
  final GoAddon addon;

  GoUserAddon copyWith({
    int? id,
    String? name,
    String? description,
    String? interval,
    String? status,
    String? amount,
    bool? recurring,
    GoUserAddonConstraint? constraint,
    GoUserAddonTimeline? timeline,
    GoUserAddonSwitching? switching,
    GoCreditCard? card,
    GoAddon? addon,
  }) {
    return GoUserAddon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      recurring: recurring ?? this.recurring,
      constraint: constraint ?? this.constraint,
      timeline: timeline ?? this.timeline,
      switching: switching ?? this.switching,
      card: card ?? this.card,
      addon: addon ?? this.addon,
    );
  }

  factory GoUserAddon.fromJson(Map<String, dynamic> json){
    return GoUserAddon(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      interval: json["interval"] ?? "",
      status: json["status"] ?? "",
      amount: json["amount"] ?? "",
      recurring: json["recurring"] ?? false,
      constraint: GoUserAddonConstraint.fromJson(json["constraint"]),
      timeline: GoUserAddonTimeline.fromJson(json["timeline"]),
      switching: json["switching"] == null ? null : GoUserAddonSwitching.fromJson(json["switching"]),
      card: GoCreditCard.fromJson(json["card"]),
      addon: GoAddon.fromJson(json["addon"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "interval": interval,
    "status": status,
    "amount": amount,
    "recurring": recurring,
    "constraint": constraint.toJson(),
    "timeline": timeline.toJson(),
    "switching": switching?.toJson(),
    "card": card.toJson(),
    "addon": addon.toJson(),
  };

  bool get hasAd => addon.isAd && (status.equalsIgnoreCase("active") || status.equalsIgnoreCase("renewal_due"));

  @override
  String toString(){
    return "$id, $name, $description, $interval, $status, $amount, $recurring, $constraint, $timeline, $switching, $card, $addon, ";
  }
}