class DirectionDistance {
  double? lat;
  double? lng;

  DirectionDistance({this.lat, this.lng});

  DirectionDistance.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }

/*
{
  "lat": 51.1797473,
  "lng": 6.8273933
}
*/
}