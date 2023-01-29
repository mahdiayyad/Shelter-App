import 'dart:convert';
import 'package:shelter/models/PostModel.dart';

StoreItemModel postModelFromJson(String str) =>
    StoreItemModel.fromJson(json.decode(str));

String postModelToJson(StoreItemModel data) => json.encode(data.toJson());

class StoreItemModel extends PostModel {
  StoreItemModel({
    image,
    required description,
    required userId,
    required this.price,
    required timestamp,
    required likes,
  }) : super(
          description: description,
          likes: likes,
          timestamp: timestamp,
          userId: userId,
          image: image,
        );

  String price;

  factory StoreItemModel.fromJson(Map<String, dynamic> json) => StoreItemModel(
        image: json["image"],
        description: json["description"],
        userId: json["userId"],
        timestamp: json["timestamp"],
        price: json["price"],
        likes: List<String>.from(json["likes"] ?? [].map((x) => x)),
      );

  @override
  Map<String, dynamic> toJson() => {
        "image": image,
        "description": description,
        "userId": userId,
        "price": price,
        "timestamp": timestamp,
        "likes": List<dynamic>.from(likes.map((x) => x)),
      };
}
