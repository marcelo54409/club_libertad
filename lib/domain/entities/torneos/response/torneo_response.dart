class TournamentResponse {
  final int id;
  final String name;
  final String type;
  final String surface;
  final String location;
  final String startDate;
  final String endDate;
  final int prizeMoney;
  final String status;
  final int totalSlots;

  TournamentResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.surface,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.prizeMoney,
    required this.status,
    required this.totalSlots,
  });

  factory TournamentResponse.fromJson(Map<String, dynamic> json) {
    return TournamentResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      surface: json['surface'],
      location: json['location'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      prizeMoney: json['prizeMoney'],
      status: json['status'],
      totalSlots: json['totalSlots'],
    );
  }
}
