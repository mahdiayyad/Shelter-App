import 'dart:convert';
import 'package:shelter/models/UserModel.dart';

StoreModel customerModelFromJson(String str) =>
    StoreModel.fromJson(json.decode(str));

String customerModelToJson(StoreModel data) => json.encode(data.toJson());

class StoreModel extends UserModel {
  StoreModel(
      {name, required email, userType, image, this.location, this.phoneNumber})
      : super(email: email, image: image, name: name, userType: userType);
  List<dynamic>? location;
  String? phoneNumber;
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel.fromJson(json);
    return StoreModel(
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      name: user.name,
      image: user.image,
      email: user.email,
      userType: user.userType,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j.addAll({"location": location, "phoneNumber": phoneNumber});
    return j;
  }
}
