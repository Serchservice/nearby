class GoPoll {
  GoPoll({
    required this.totalNearbyUsersWithSameSharedInterest,
    required this.totalUsersWithSameSharedInterest,
    required this.totalAttendingUsers,
  });

  final int totalNearbyUsersWithSameSharedInterest;
  final int totalUsersWithSameSharedInterest;
  final int totalAttendingUsers;

  GoPoll copyWith({
    int? totalNearbyUsersWithSameSharedInterest,
    int? totalUsersWithSameSharedInterest,
    int? totalAttendingUsers,
  }) {
    return GoPoll(
      totalNearbyUsersWithSameSharedInterest: totalNearbyUsersWithSameSharedInterest ?? this.totalNearbyUsersWithSameSharedInterest,
      totalUsersWithSameSharedInterest: totalUsersWithSameSharedInterest ?? this.totalUsersWithSameSharedInterest,
      totalAttendingUsers: totalAttendingUsers ?? this.totalAttendingUsers,
    );
  }

  factory GoPoll.fromJson(Map<String, dynamic> json){
    return GoPoll(
      totalNearbyUsersWithSameSharedInterest: json["total_nearby_users_with_same_shared_interest"] ?? 0,
      totalUsersWithSameSharedInterest: json["total_users_with_same_shared_interest"] ?? 0,
      totalAttendingUsers: json["total_attending_users"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "total_nearby_users_with_same_shared_interest": totalNearbyUsersWithSameSharedInterest,
    "total_users_with_same_shared_interest": totalUsersWithSameSharedInterest,
    "total_attending_users": totalAttendingUsers,
  };

  @override
  String toString(){
    return "$totalNearbyUsersWithSameSharedInterest, $totalUsersWithSameSharedInterest, $totalAttendingUsers, ";
  }
}