import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.image,
    required this.description,
    required this.userId,
    required this.timestamp,
    required this.likes,
  });

  String? image;
  String description;
  String userId;
  Timestamp timestamp;
  List<String> likes;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        image: json["image"],
        description: json["description"],
        userId: json["userId"],
        timestamp: json["timestamp"],
        likes: List<String>.from(json["likes"] ?? [].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "description": description,
        "userId": userId,
        "timestamp": timestamp,
        "likes": List<dynamic>.from(likes.map((x) => x)),
      };
}
