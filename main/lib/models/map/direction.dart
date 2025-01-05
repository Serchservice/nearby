import 'package:drive/library.dart';

class Direction {
  String? instructions;
  DirectionDistance? distance;

  Direction({this.instructions, this.distance});

  Direction.fromJson(Map<String, dynamic> json) {
    instructions = json['instructions']?.toString();
    distance = (json['distance'] != null) ? DirectionDistance.fromJson(json['distance']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['instructions'] = instructions;
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    return data;
  }

/*
{
  "instructions": "Head <b>southwest</b> toward <b>Kölner Landstraße</b><div style=\"font-size:0.9em\">Restricted usage road</div>",
  "distance": {
    "lat": 51.1797473,
    "lng": 6.8273933
  }
}
*/
}