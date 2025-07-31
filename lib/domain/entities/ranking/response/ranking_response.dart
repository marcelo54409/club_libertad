class RankingResponse {
  final int id;
  final int playerId;
  final int position;
  final int points;
  final String category;
  final int weekNumber;
  final int year;
  final Player player;

  RankingResponse({
    required this.id,
    required this.playerId,
    required this.position,
    required this.points,
    required this.category,
    required this.weekNumber,
    required this.year,
    required this.player,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    return RankingResponse(
      id: json['id'],
      playerId: json['playerId'],
      position: json['position'],
      points: json['points'],
      category: json['category'],
      weekNumber: json['weekNumber'],
      year: json['year'],
      player: Player.fromJson(json['Player']),
    );
  }
}

class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String countryCode;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      countryCode: json['countryCode'],
    );
  }
}

class RankingMetadata {
  final String category;
  final int year;
  final int week;
  final int totalPlayers;
  final DateTime lastUpdated;

  RankingMetadata({
    required this.category,
    required this.year,
    required this.week,
    required this.totalPlayers,
    required this.lastUpdated,
  });

  factory RankingMetadata.fromJson(Map<String, dynamic> json) {
    return RankingMetadata(
      category: json['category'],
      year: json['year'],
      week: json['week'],
      totalPlayers: json['totalPlayers'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class RankingFullResponse {
  final List<RankingResponse> rankings;
  final RankingMetadata metadata;

  RankingFullResponse({
    required this.rankings,
    required this.metadata,
  });

  factory RankingFullResponse.fromJson(Map<String, dynamic> json) {
    return RankingFullResponse(
      rankings: (json['rankings'] as List)
          .map((item) => RankingResponse.fromJson(item))
          .toList(),
      metadata: RankingMetadata.fromJson(json['metadata']),
    );
  }
}
