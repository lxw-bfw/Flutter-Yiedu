// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..userInfo = json['userInfo'] == null
        ? null
        : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
    ..theme = json['theme'] as int
    ..brightnessStyle = json['brightnessStyle'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userInfo': instance.userInfo,
      'theme': instance.theme,
      'brightnessStyle': instance.brightnessStyle
    };
