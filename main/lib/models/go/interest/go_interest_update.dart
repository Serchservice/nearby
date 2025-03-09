import 'go_interest_category.dart';

class GoInterestUpdate {
  GoInterestUpdate({
    required this.taken,
    required this.reserved,
  });

  final List<GoInterestCategory> taken;
  final List<GoInterestCategory> reserved;

  GoInterestUpdate copyWith({
    List<GoInterestCategory>? taken,
    List<GoInterestCategory>? reserved,
  }) {
    return GoInterestUpdate(
      taken: taken ?? this.taken,
      reserved: reserved ?? this.reserved,
    );
  }

  factory GoInterestUpdate.fromJson(Map<String, dynamic> json){
    return GoInterestUpdate(
      taken: json["taken"] == null
          ? []
          : List<GoInterestCategory>.from(json["taken"]!.map((x) => GoInterestCategory.fromJson(x))),
      reserved: json["reserved"] == null
          ? []
          : List<GoInterestCategory>.from(json["reserved"]!.map((x) => GoInterestCategory.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "taken": taken.map((x) => x.toJson()).toList(),
    "reserved": reserved.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$taken, $reserved, ";
  }
}