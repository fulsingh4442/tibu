// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    CategoryModel({
        this.status,
        this.data,
        this.error,
    });

    bool status;
    List<CategoryList> data;
    String error;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json["status"],
        data: List<CategoryList>.from(json["data"].map((x) => CategoryList.fromJson(x))),
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": error,
    };
}

class CategoryList {
    CategoryList({
        this.id,
        this.name,
        this.status,
    });

    String id;
    String name;
    String status;

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
    };
}
