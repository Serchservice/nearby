import 'package:drive/library.dart';
import 'package:smart/smart.dart' show StringExtensions;

class GoAuthResponse {
  final String contact;
  final String avatar;
  final String id;
  final String session;
  final String firstName;
  final String lastName;
  final String emailAddress;

  GoAuthResponse({
    required this.contact,
    required this.avatar,
    required this.id,
    required this.session,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
  });

  GoAuthResponse copyWith({
    String? contact,
    String? avatar,
    String? id,
    String? session,
    String? firstName,
    String? lastName,
    String? emailAddress,
  }) {
    return GoAuthResponse(
      contact: contact ?? this.contact,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      session: session ?? this.session,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  factory GoAuthResponse.fromJson(Map<String, dynamic> json){
    return GoAuthResponse(
      contact: json["contact"] ?? "",
      avatar: json["avatar"] ?? "",
      id: json["id"] ?? "",
      session: json["session"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      emailAddress: json["email_address"] ?? "",
    );
  }

  factory GoAuthResponse.empty() {
    return GoAuthResponse.fromJson({});
  }

  Map<String, dynamic> toJson() => {
    "contact": contact,
    "avatar": avatar,
    "id": id,
    "session": session,
    "first_name": firstName,
    "last_name": lastName,
    "email_address": emailAddress,
  };

  bool get isLoggedIn => session.isNotEmpty;

  String get fullName => "$firstName $lastName";

  String get initials => "${firstName.first(1)}${lastName.first(1)}";

  String get image => avatar.isEmpty ? AssetUtility.defaultImage : avatar;

  @override
  String toString(){
    return "$contact, $avatar, $id, $session, $firstName, $lastName, $emailAddress, ";
  }
}