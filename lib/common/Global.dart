
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectpractice/models/user.dart';

/**
 * app全局变量或状态管理：比如app一次登录，是创建一个User单例，贯穿整个app的生命周期，其中user单例是保存再global里面。
 * app启动之前需要进行全局变量的初始化和判断。此外user是进行数据持久化的，所以获取是从持久化数据里面获取
 */

// 提供两套6套主题可供选择：核心是：白天模式、黑夜模式,默认是白天模式，用户可以自己主题设置里面设置，仿照掘金
// 当前主题仅仅涉及状态栏的primarycolor也就是：也就是materialapp提供是设置主题的api theme下的primarySwatch属性
/**
 * 在 Flutter 项目中，MaterialApp组件为开发者提供了设置主题的api：
 * theme属性：
 * ThemeData({
    
    *Brightness brightness,
    *MaterialColor primarySwatch,
    *Color primaryColor,
    *Brightness primaryColorBrightness,
    *Color primaryColorLight,
    *Color primaryColorDark,
    
   * ...
   * red,
    pink,
    purple,
    deepPurple,
    indigo,
    blue,
    lightBlue,
    cyan,
    teal,
    green,
    lightGreen,
    lime,
    yellow,
    amber,
    orange,
    deepOrange,
    brown,
    // The grey swatch is intentionally omitted because when picking a color
    // randomly from this list to colorize an application, picking grey suddenly
    // makes the app look disabled.
    blueGrey,
 
  })
 */
final List<MaterialColor> themeList = [
  Colors.pink,
  Colors.blue,
  Colors.cyan,
  Colors.amber,
  Colors.green,
  Colors.lime
];

class Global {
  // 登录用户信息：数据持久化
  static SharedPreferences _prefs;
  static User user = User();

 //可选主题列表
 static List<Color> get themes => themeList;

 // 初始化全局信息，每次打开app，访问缓存里面的信息（你需要持久化的信息比如用户信息）app启动的时候执行
 static Future init() async{
   _prefs = await SharedPreferences.getInstance();
   var _user = _prefs.getString('user');
   if (user !=null) {
     try {
       user = User.fromJson(jsonDecode(_user));
     } catch (e) {
       print(e);
     }
   }

   //TODO: 初始化网络配置，引入封装的dio模块
   // YiEdu.init();
 }

 // 持久化用户信息:任何修改用户行为后台保存成功后获取到返回信息后就要持久化用户信息。
 static saveUser () => _prefs.setString('user', jsonEncode(user.toJson()));

}

