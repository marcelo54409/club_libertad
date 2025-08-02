class TournamentResponse {
  final int id;
  final String name;
  final String type;
  final String? level;
  final String surface;
  final String location;
  final String startDate;
  final String endDate;
  final String? prizeMoney;
  final String? registrationFee;
  final String? currency;
  final String status;
  final int totalSlots;
  final int currentRegistrations;
  final int? points;
  final String createdAt;
  final String updatedAt;

  TournamentResponse({
    required this.id,
    required this.name,
    required this.type,
    this.level,
    required this.surface,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.prizeMoney,
    this.registrationFee,
    this.currency,
    required this.status,
    required this.totalSlots,
    required this.currentRegistrations,
    this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TournamentResponse.fromJson(Map<String, dynamic> json) {
    return TournamentResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      level: json['level'],
      surface: json['surface'],
      location: json['location'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      prizeMoney: json['prizeMoney'],
      registrationFee: json['registrationFee'],
      currency: json['currency'],
      status: json['status'],
      totalSlots: json['totalSlots'],
      currentRegistrations: json['currentRegistrations'],
      points: json['points'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
