import 'dart:convert';
import 'package:shelter/models/PostModel.dart';

StorePetModel postModelFromJson(String str) =>
    StorePetModel.fromJson(json.decode(str));

String postModelToJson(StorePetModel data) => json.encode(data.toJson());

class StorePetModel extends PostModel {
  StorePetModel(
      {image,
      required description,
      required userId,
      required this.price,
      required timestamp,
      required likes,
      required this.name,
      required this.age,
      required this.gender,
      required this.type})
      : super(
          description: description,
          likes: likes,
          timestamp: timestamp,
          userId: userId,
          image: image,
        );

  String price;
  String? name;
  int? age;
  String? gender;
  String? type;

  factory StorePetModel.fromJson(Map<String, dynamic> json) => StorePetModel(
        image: json["image"],
        description: json["description"],
        userId: json["userId"],
        timestamp: json["timestamp"],
        name: json["name"],
        price: json["price"],
        age: json["age"],
        gender: json["gender"],
        type: json["type"],
        likes: List<String>.from(json["likes"] ?? [].map((x) => x)),
      );

  @override
  Map<String, dynamic> toJson() => {
        "image": image,
        "description": description,
        "userId": userId,
        "price": price,
        "timestamp": timestamp,
        "name": name,
        "age": age,
        "gender": gender,
        "type": type,
        "likes": List<dynamic>.from(likes.map((x) => x)),
      };
}
