import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/models/index.dart';
import 'package:provider/provider.dart';

/**
 * 管理app共享的状态的数据
 */

// 用户以及用户登录信息：登录用户信息的共享。
class UserModel with ChangeNotifier {
  // user单例：登录用户信息,生命为私有属性
   User _user = Global.user;

   //访问器属性:本身是一个方法
   User get user => _user;
  
  //登录标识
   bool get isLogin => _user != null;

   //修改用户信息，触发重新更新wiget
   void changeUserInfo(User user){
      Global.user = user;
      _user = user;
      notifyListeners();
   }

}

// app主题状态管理:由于主题是保存再用户下的，所以我们继承usermodel，更新的主题的时候夜更新用户信息

// 如果我把界面的当前主题颜色字段theme放在了user字段里面的话，那么我的状态管理，我只要管理user就行了吧，
//比如主题，provider获取usermodel里面的_user，更新信息的话，先获取_user再对更新的字段进行设置再调用里面的set User...Global

//管理带有单选框、复选框，删除的逻辑状态
class CheceBox with ChangeNotifier{
  bool _isShowDelete = false;
  get isShowDelete => _isShowDelete;
  List<int> _deleteIds = [];
  get deleteIds => _deleteIds;

  toggleShow(bool show){
    _isShowDelete = show;
    notifyListeners();
  }

  changeDeleteIds(List<int> list){
    _deleteIds = list;
    notifyListeners();
  }

}
