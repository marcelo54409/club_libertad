class RankingRequest {
  final String? category;
  final int? year;
  final int? week;
  final int? limit;

  RankingRequest({
    this.category,
    this.year,
    this.week,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category,
      if (year != null) 'year': year,
      if (week != null) 'week': week,
      if (limit != null) 'limit': limit,
    };
  }
}
