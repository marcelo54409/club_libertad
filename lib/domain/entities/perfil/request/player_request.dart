class PlayerRequest {
  final int? limit;
  final int? offset;

  PlayerRequest({
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }
}
