import 'dart:convert';

InicioResponse inicioResponseFromJson(String str) =>
    InicioResponse.fromJson(json.decode(str));

String inicioResponseToJson(InicioResponse data) =>
    json.encode(data.toJson());

class InicioResponse {
  final bool success;
  final String message;
  final MatchData? data;
  final dynamic error;
  final Map<String, dynamic>? meta;

  InicioResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.meta,
  });

  factory InicioResponse.fromJson(Map<String, dynamic> json) => InicioResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? MatchData.fromJson(json["data"]) : null,
        error: json["error"],
        meta: json["meta"] != null ? Map<String, dynamic>.from(json["meta"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "error": error,
        "meta": meta,
      };
}

class MatchData {
  final int id;
  final int tournamentId;
  final String round;
  final int player1Id;
  final int player2Id;
  final int winnerId;
  final String score;
  final DateTime dateTime;
  final String court;
  final int durationMinutes;
  final int aces1;
  final int aces2;
  final int winners1;
  final int winners2;
  final int longestRallySeconds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Player player1;
  final Player player2;
  final Player winner;

  MatchData({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.player1Id,
    required this.player2Id,
    required this.winnerId,
    required this.score,
    required this.dateTime,
    required this.court,
    required this.durationMinutes,
    required this.aces1,
    required this.aces2,
    required this.winners1,
    required this.winners2,
    required this.longestRallySeconds,
    required this.createdAt,
    required this.updatedAt,
    required this.player1,
    required this.player2,
    required this.winner,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        id: json["id"],
        tournamentId: json["tournamentId"],
        round: json["round"],
        player1Id: json["player1Id"],
        player2Id: json["player2Id"],
        winnerId: json["winnerId"],
        score: json["score"],
        dateTime: DateTime.parse(json["dateTime"]),
        court: json["court"],
        durationMinutes: json["durationMinutes"],
        aces1: json["aces1"],
        aces2: json["aces2"],
        winners1: json["winners1"],
        winners2: json["winners2"],
        longestRallySeconds: json["longestRallySeconds"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        player1: Player.fromJson(json["Player1"]),
        player2: Player.fromJson(json["Player2"]),
        winner: Player.fromJson(json["Winner"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tournamentId": tournamentId,
        "round": round,
        "player1Id": player1Id,
        "player2Id": player2Id,
        "winnerId": winnerId,
        "score": score,
        "dateTime": dateTime.toIso8601String(),
        "court": court,
        "durationMinutes": durationMinutes,
        "aces1": aces1,
        "aces2": aces2,
        "winners1": winners1,
        "winners2": winners2,
        "longestRallySeconds": longestRallySeconds,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Player1": player1.toJson(),
        "Player2": player2.toJson(),
        "Winner": winner.toJson(),
      };
}

class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String countryCode;
  final String city;
  final DateTime dateOfBirth;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player({
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

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        countryCode: json["countryCode"],
        city: json["city"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        profilePicture: json["profilePicture"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "countryCode": countryCode,
        "city": city,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "profilePicture": profilePicture,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

TorneosProgresoResponse torneosProgresoResponseFromJson(String str) =>
    TorneosProgresoResponse.fromJson(json.decode(str));

String torneosProgresoResponseToJson(TorneosProgresoResponse data) =>
    json.encode(data.toJson());

class TorneosProgresoResponse {
  final List<Torneo> tournaments;
  final int count;

  TorneosProgresoResponse({
    required this.tournaments,
    required this.count,
  });

  factory TorneosProgresoResponse.fromJson(Map<String, dynamic> json) =>
      TorneosProgresoResponse(
        tournaments: List<Torneo>.from(
            json["tournaments"].map((x) => Torneo.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "tournaments": List<dynamic>.from(tournaments.map((x) => x.toJson())),
        "count": count,
      };
}

class Torneo {
  final int id;
  final String name;
  final String type;
  final String surface;
  final String location;
  final String status;
  final String? startDate;
  final String? endDate;

  Torneo({
    required this.id,
    required this.name,
    required this.type,
    required this.surface,
    required this.location,
    required this.status,
    this.startDate,
    this.endDate,
  });

  factory Torneo.fromJson(Map<String, dynamic> json) => Torneo(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        surface: json["surface"],
        location: json["location"],
        status: json["status"],
        startDate: json["startDate"],
        endDate: json["endDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "surface": surface,
        "location": location,
        "status": status,
        "startDate": startDate,
        "endDate": endDate,
      };
}
PartidosProgramadosResponse partidosProgramadosResponseFromJson(String str) =>
    PartidosProgramadosResponse.fromJson(json.decode(str));

String partidosProgramadosResponseToJson(PartidosProgramadosResponse data) =>
    json.encode(data.toJson());

class PartidosProgramadosResponse {
  final List<MatchProgramado> matches;
  final Metadata metadata;

  PartidosProgramadosResponse({
    required this.matches,
    required this.metadata,
  });

  factory PartidosProgramadosResponse.fromJson(Map<String, dynamic> json) =>
      PartidosProgramadosResponse(
        matches: List<MatchProgramado>.from(
            json["matches"].map((x) => MatchProgramado.fromJson(x))),
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
        "metadata": metadata.toJson(),
      };
}

class MatchProgramado {
  final int id;
  final int tournamentId;
  final String round;
  final int player1Id;
  final int player2Id;
  final int? winnerId;
  final String? score;
  final DateTime dateTime;
  final String court;
  final MiniPlayer player1;
  final MiniPlayer player2;

  MatchProgramado({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.player1Id,
    required this.player2Id,
    this.winnerId,
    this.score,
    required this.dateTime,
    required this.court,
    required this.player1,
    required this.player2,
  });

  factory MatchProgramado.fromJson(Map<String, dynamic> json) =>
      MatchProgramado(
        id: json["id"],
        tournamentId: json["tournamentId"],
        round: json["round"],
        player1Id: json["player1Id"],
        player2Id: json["player2Id"],
        winnerId: json["winnerId"],
        score: json["score"],
        dateTime: DateTime.parse(json["dateTime"]),
        court: json["court"],
        player1: MiniPlayer.fromJson(json["Player1"]),
        player2: MiniPlayer.fromJson(json["Player2"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tournamentId": tournamentId,
        "round": round,
        "player1Id": player1Id,
        "player2Id": player2Id,
        "winnerId": winnerId,
        "score": score,
        "dateTime": dateTime.toIso8601String(),
        "court": court,
        "Player1": player1.toJson(),
        "Player2": player2.toJson(),
      };
}

class MiniPlayer {
  final String firstName;
  final String lastName;

  MiniPlayer({
    required this.firstName,
    required this.lastName,
  });

  factory MiniPlayer.fromJson(Map<String, dynamic> json) => MiniPlayer(
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}

class Metadata {
  final int days;
  final int limit;
  final bool featured;
  final int totalUpcoming;

  Metadata({
    required this.days,
    required this.limit,
    required this.featured,
    required this.totalUpcoming,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        days: json["days"],
        limit: json["limit"],
        featured: json["featured"],
        totalUpcoming: json["totalUpcoming"],
      );

  Map<String, dynamic> toJson() => {
        "days": days,
        "limit": limit,
        "featured": featured,
        "totalUpcoming": totalUpcoming,
      };
}
// Añadir al final del archivo existente

JugadoresDestacadosResponse jugadoresDestacadosResponseFromJson(String str) =>
    JugadoresDestacadosResponse.fromJson(json.decode(str));

String jugadoresDestacadosResponseToJson(JugadoresDestacadosResponse data) =>
    json.encode(data.toJson());

class JugadoresDestacadosResponse {
  final List<Player> players;
  final int count;

  JugadoresDestacadosResponse({
    required this.players,
    required this.count,
  });

  factory JugadoresDestacadosResponse.fromJson(Map<String, dynamic> json) =>
      JugadoresDestacadosResponse(
        players: List<Player>.from(
            json["players"].map((x) => Player.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "players": List<dynamic>.from(players.map((x) => x.toJson())),
        "count": count,
      };
}

class Ranking {
  final int position;
  final int points;

  Ranking({
    required this.position,
    required this.points,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) => Ranking(
        position: json["position"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "points": points,
      };
}
