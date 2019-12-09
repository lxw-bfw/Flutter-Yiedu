import 'package:json_annotation/json_annotation.dart';

part 'userInfo.g.dart';

@JsonSerializable()
class UserInfo {
    UserInfo();

    String stuid;
    num roleId;
    String petname;
    String stuname;
    String stupassword;
    String stusex;
    num stuage;
    String birthday;
    String role;
    String phone;
    String email;
    String qq;
    num registertime;
    String address;
    String stuintroduce;
    String integral;
    num state;
    
    factory UserInfo.fromJson(Map<String,dynamic> json) => _$UserInfoFromJson(json);
    Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
