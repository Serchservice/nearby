class GoUserAddonConstraint {
  GoUserAddonConstraint({
    required this.canRenew,
    required this.canCancel,
    required this.canSwitch,
    required this.canActivate,
  });

  final bool canRenew;
  final bool canCancel;
  final bool canSwitch;
  final bool canActivate;

  GoUserAddonConstraint copyWith({
    bool? canRenew,
    bool? canCancel,
    bool? canSwitch,
    bool? canActivate,
  }) {
    return GoUserAddonConstraint(
      canRenew: canRenew ?? this.canRenew,
      canCancel: canCancel ?? this.canCancel,
      canSwitch: canSwitch ?? this.canSwitch,
      canActivate: canActivate ?? this.canActivate,
    );
  }

  factory GoUserAddonConstraint.fromJson(Map<String, dynamic> json){
    return GoUserAddonConstraint(
      canRenew: json["can_renew"] ?? false,
      canCancel: json["can_cancel"] ?? false,
      canSwitch: json["can_switch"] ?? false,
      canActivate: json["can_activate"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "can_renew": canRenew,
    "can_cancel": canCancel,
    "can_switch": canSwitch,
    "can_activate": canActivate,
  };

  @override
  String toString(){
    return "$canRenew, $canCancel, $canSwitch, $canActivate, ";
  }
}