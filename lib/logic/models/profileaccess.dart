// To parse this JSON data, do
//
//     final profileAccessModel = profileAccessModelFromJson(jsonString);

import 'dart:convert';

ProfileAccessModel profileAccessModelFromJson(String str) => ProfileAccessModel.fromJson(json.decode(str));

String profileAccessModelToJson(ProfileAccessModel data) => json.encode(data.toJson());

class ProfileAccessModel {
    ProfileAccessModel({
        this.status,
        this.error,
        this.data,
    });

    bool status;
    dynamic error;
    Data data;

    factory ProfileAccessModel.fromJson(Map<String, dynamic> json) => ProfileAccessModel(
        status: json["status"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.staff,
        this.id,
        this.firstName,
        this.lastName,
        this.gender,
        this.phone,
        this.email,
        this.status,
        this.accessKey,
    });

    String staff;
    int id;
    String firstName;
    String lastName;
    String gender;
    String phone;
    String email;
    String status;
    String accessKey;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        staff: json["staff"],
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        status: json["status"],
        accessKey: json["access_key"],
    );

    Map<String, dynamic> toJson() => {
        "staff": staff,
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "phone": phone,
        "email": email,
        "status": status,
        "access_key": accessKey,
    };
}
