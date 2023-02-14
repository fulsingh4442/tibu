// To parse this JSON data, do
//
//     final deleteEventResponse = deleteEventResponseFromJson(jsonString);

import 'dart:convert';

DeleteEventResponse deleteEventResponseFromJson(String str) => DeleteEventResponse.fromJson(json.decode(str));

String deleteEventResponseToJson(DeleteEventResponse data) => json.encode(data.toJson());

class DeleteEventResponse {
    DeleteEventResponse({
        this.status,
        this.error,
    });

    bool status;
    dynamic error;

    factory DeleteEventResponse.fromJson(Map<String, dynamic> json) => DeleteEventResponse(
        status: json["status"] == null ? null : json["status"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "error": error,
    };
}
