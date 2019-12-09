import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import "userInfo.dart";
part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    UserInfo userInfo;
    int theme;
    String brightnessStyle;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
