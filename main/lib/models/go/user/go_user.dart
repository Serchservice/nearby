class GoUser {
  GoUser({
    required this.contact,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
  });

  final String contact;
  final String avatar;
  final String firstName;
  final String lastName;
  final String emailAddress;

  GoUser copyWith({
    String? contact,
    String? avatar,
    String? firstName,
    String? lastName,
    String? emailAddress,
  }) {
    return GoUser(
      contact: contact ?? this.contact,
      avatar: avatar ?? this.avatar,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  factory GoUser.fromJson(Map<String, dynamic> json){
    return GoUser(
      contact: json["contact"] ?? "",
      avatar: json["avatar"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      emailAddress: json["email_address"] ?? "",
    );
  }

  String get fullName => "$firstName $lastName";

  Map<String, dynamic> toJson() => {
    "contact": contact,
    "avatar": avatar,
    "first_name": firstName,
    "last_name": lastName,
    "email_address": emailAddress,
  };

  @override
  String toString(){
    return "$contact, $avatar, $firstName, $lastName, $emailAddress, ";
  }
}