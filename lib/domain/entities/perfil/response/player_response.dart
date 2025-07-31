class PlayerResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String countryCode;
  final String city;
  final DateTime dateOfBirth;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.city,
    required this.dateOfBirth,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      countryCode: json['countryCode'],
      city: json['city'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PlayerPageInfo {
  final int limit;
  final int offset;
  final bool hasNext;

  PlayerPageInfo({
    required this.limit,
    required this.offset,
    required this.hasNext,
  });

  factory PlayerPageInfo.fromJson(Map<String, dynamic> json) {
    return PlayerPageInfo(
      limit: json['limit'],
      offset: json['offset'],
      hasNext: json['hasNext'],
    );
  }
}

class PlayerFullResponse {
  final List<PlayerResponse> players;
  final int total;
  final PlayerPageInfo page;

  PlayerFullResponse({
    required this.players,
    required this.total,
    required this.page,
  });

  factory PlayerFullResponse.fromJson(Map<String, dynamic> json) {
    return PlayerFullResponse(
      players: (json['players'] as List)
          .map((e) => PlayerResponse.fromJson(e))
          .toList(),
      total: json['total'],
      page: PlayerPageInfo.fromJson(json['page']),
    );
  }
}
