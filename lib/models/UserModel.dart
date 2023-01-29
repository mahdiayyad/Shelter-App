import 'dart:convert';

UserModel customerModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String customerModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.name,
    required this.email,
    this.userType,
    this.image,
  });

  String? name;
  String? email;
  String? image;
  String? userType;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        image: json["image"],
        email: json["email"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "image": image,
        "userType": userType,
      };
}
