class TournamentRequest {
  final String? status;
  final String? type;
  final String? surface;
  final int? year;
  final int? limit;
  final int? offset;

  TournamentRequest({
    this.status,
    this.type,
    this.surface,
    this.year,
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (surface != null) 'surface': surface,
      if (year != null) 'year': year,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }
}
