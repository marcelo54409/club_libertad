// To parse this JSON data, do
//
//     final configuracionResponse = parametrosResponseFromJson(jsonString);

import 'package:club_libertad_front/domain/entities/base_params.dart';
import 'package:club_libertad_front/domain/entities/common/interfaces/i_base_params.dart';

class InicioRequest extends BaseParams implements IBaseParams {
  int? tournamentId;
  int? days;
  int? limit;
  bool? featured;
  String? category;

  InicioRequest({
    this.tournamentId,
    this.days,
    this.limit,
    this.featured,
    this.category,
  });

  factory InicioRequest.fromJson(Map<String, dynamic> json) => InicioRequest(
        tournamentId: json["tournamentId"],
        days: json["days"],
        limit: json["limit"],
        featured: json["featured"],
        category: json["category"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "tournamentId": tournamentId,
        "days": days,
        "limit": limit,
        "featured": featured,
        "category": category,
      };
}
