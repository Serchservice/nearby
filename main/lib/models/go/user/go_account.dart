import 'package:drive/library.dart' show Address;
import 'package:smart/smart.dart' show StringExtensions;

class GoAccount {
  GoAccount({
    required this.contact,
    required this.avatar,
    required this.id,
    required this.timezone,
    required this.location,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.searchRadius,
    required this.emailConfirmedAt,
    required this.joinedOn,
  });

  final String contact;
  final String avatar;
  final String id;
  final String timezone;
  final Address? location;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final double searchRadius;
  final String emailConfirmedAt;
  final String joinedOn;

  GoAccount copyWith({
    String? contact,
    String? avatar,
    String? id,
    String? timezone,
    Address? location,
    String? firstName,
    String? lastName,
    String? emailAddress,
    double? searchRadius,
    String? emailConfirmedAt,
    String? joinedOn,
  }) {
    return GoAccount(
      contact: contact ?? this.contact,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      timezone: timezone ?? this.timezone,
      location: location ?? this.location,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
      searchRadius: searchRadius ?? this.searchRadius,
      emailConfirmedAt: emailConfirmedAt ?? this.emailConfirmedAt,
      joinedOn: joinedOn ?? this.joinedOn,
    );
  }

  factory GoAccount.fromJson(Map<String, dynamic> json) {
    return GoAccount(
      contact: json["contact"] ?? "",
      avatar: json["avatar"] ?? "",
      id: json["id"] ?? "",
      timezone: json["timezone"] ?? "",
      location: json["location"] == null ? null : Address.fromJson(json["location"]),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      emailAddress: json["email_address"] ?? "",
      searchRadius: json["search_radius"] ?? 0.0,
      emailConfirmedAt: json["email_confirmed_at"] ?? "",
      joinedOn: json["joined_on"] ?? "",
    );
  }

  factory GoAccount.empty() => GoAccount.fromJson({});

  bool get isEmpty => id.isEmpty && emailAddress.isEmpty;

  String get fullName => "$firstName $lastName";

  String get initials => "${firstName.first(1)}${lastName.first(1)}";

  Map<String, dynamic> toJson() => {
    "contact": contact,
    "avatar": avatar,
    "id": id,
    "timezone": timezone,
    "location": location?.toJson(),
    "first_name": firstName,
    "last_name": lastName,
    "email_address": emailAddress,
    "search_radius": searchRadius,
    "email_confirmed_at": emailConfirmedAt,
    "joined_on": joinedOn,
  };

  @override
  String toString(){
    return "$contact, $avatar, $id, $timezone, $location, $firstName, $lastName, $emailAddress, $searchRadius, $emailConfirmedAt, $joinedOn, ";
  }
}