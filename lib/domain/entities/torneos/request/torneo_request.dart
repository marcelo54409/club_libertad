class TournamentRequest {
  final String? status;
  final String? type;
  final String? surface;
  final String? level;
  final String? location;
  final int? year;
  final int? limit;
  final int? offset;

  TournamentRequest({
    this.status,
    this.type,
    this.surface,
    this.level,
    this.location,
    this.year,
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (surface != null) 'surface': surface,
      if (level != null) 'level': level,
      if (location != null) 'location': location,
      if (year != null) 'year': year,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }
}
