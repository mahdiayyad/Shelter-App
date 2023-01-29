import 'dart:convert';

import 'package:shelter/models/StoreModel.dart';
import 'package:shelter/models/UserModel.dart';

//*************************************************************************************/
//************************************ClinicModel**************************************/
//*************************************************************************************/

ClinicModel customerModelFromJson(String str) =>
    ClinicModel.fromJson(json.decode(str));

String customerModelToJson(ClinicModel data) => json.encode(data.toJson());

class ClinicModel extends StoreModel {
  ClinicModel(
      {name,
      required email,
      userType,
      image,
      location,
      phoneNumber,
      required this.likes,
      this.description})
      : super(email: email, image: image, name: name, userType: userType);

  String? description;

  List<String> likes;

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel.fromJson(json);
    return ClinicModel(
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      likes: List<String>.from(json["likes"] ?? [].map((x) => x)),
      name: user.name,
      image: user.image,
      email: user.email,
      userType: user.userType,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j.addAll({
      "location": location,
      "likes": List<dynamic>.from(likes.map((x) => x)),
      "description": description,
      "phoneNumber": phoneNumber,
    });
    return j;
  }
}
