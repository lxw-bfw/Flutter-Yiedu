// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo()
    ..stuid = json['stuid'] as String
    ..roleId = json['roleId'] as num
    ..petname = json['petname'] as String
    ..stuname = json['stuname'] as String
    ..stupassword = json['stupassword'] as String
    ..stusex = json['stusex'] as String
    ..stuage = json['stuage'] as num
    ..birthday = json['birthday'] as String
    ..role = json['role'] as String
    ..phone = json['phone'] as String
    ..email = json['email'] as String
    ..qq = json['qq'] as String
    ..registertime = json['registertime'] as num
    ..address = json['address'] as String
    ..stuintroduce = json['stuintroduce'] as String
    ..integral = json['integral'] as String
    ..state = json['state'] as num;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'stuid': instance.stuid,
      'roleId': instance.roleId,
      'petname': instance.petname,
      'stuname': instance.stuname,
      'stupassword': instance.stupassword,
      'stusex': instance.stusex,
      'stuage': instance.stuage,
      'birthday': instance.birthday,
      'role': instance.role,
      'phone': instance.phone,
      'email': instance.email,
      'qq': instance.qq,
      'registertime': instance.registertime,
      'address': instance.address,
      'stuintroduce': instance.stuintroduce,
      'integral': instance.integral,
      'state': instance.state
    };
