import 'package:meta/meta.dart';
import 'dart:convert';

StandartResponse standartResponseFromJson(String str) => StandartResponse.fromJson(json.decode(str));

String standartResponseToJson(StandartResponse data) => json.encode(data.toJson());

class StandartResponse {
    StandartResponse({
        required this.status,
    });

    final String status;

    factory StandartResponse.fromJson(Map<String, dynamic> json) => StandartResponse(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
