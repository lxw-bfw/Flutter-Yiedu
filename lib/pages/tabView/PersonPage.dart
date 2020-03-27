import 'package:flutter/material.dart';
import 'package:projectpractice/widget/ListItem.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/models/index.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'package:provider/provider.dart';
import 'package:projectpractice/pages/login/LoginIndex.dart';
import 'package:projectpractice/pages/person/PersonData.dart';
import 'package:projectpractice/pages/person/MySign.dart';
import 'package:projectpractice/pages/person/MyOrder.dart';

class PersonPage extends StatefulWidget {
  PersonPage({Key key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

// 界面状态还有样式的控制
class _PersonPageState extends State<PersonPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _switchSelected = false; //维护单选开关状态

  @override
  Widget build(BuildContext context) {
    //判断是的登录
    UserModel userModel = Provider.of<UserModel>(context);
    //这就是一个新的页面虽然不会覆盖状态栏，但是你可以根据自己的需要定制页面。
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/personbg1.jpg'),
                        fit: BoxFit.cover)),
                //文字居中
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '专注生活|专注工作|做更好的自己',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
              ),
              //头像
              Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 120.0, 10.0, 0.0),
                  child: Container(
                      height: 130.0,
                      // padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          //圆形头像
                          ClipOval(
                            child: Container(
                              child: Image(
                                image: AssetImage('images/header1.jpeg'),
                                height: 115,
                                width: 115,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ))),
              //昵称
              Padding(
                padding: EdgeInsets.fromLTRB(150.0, 190.0, 50.0, 10.0),
                //TODO:判断是否登录，是的话就显示用户名信息需信息，否的话就显示未登录
                child: userModel.isLogin
                    ? Text(
                        userModel.user.userInfo.stuname!=null? userModel.user.userInfo.stuname : 'Mr.Liu' ,//用户名称渲染
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      )
                    : GestureDetector(
                        child: Text(
                          '未登录',
                          style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginIndex();
                          }));
                        },
                      ),
              ),
              // 性别
              Padding(
                  padding: EdgeInsets.fromLTRB(210.0, 190.0, 50.0, 10.0),
                  child: userModel.isLogin
                      ? Image(
                          image: userModel.user.userInfo.stusex=='男'? AssetImage('images/man.png') : AssetImage('images/sex-woman.png'),
                          width: 25.0,
                          height: 25.0,
                        )
                      : Text(''))
            ],
          ),
          //相关信息列表页面
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            height: 300.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), //3像素圆角
                color: Colors.white),
            child: Column(
              children: <Widget>[
                //自己封装的列表项组件
                ListItem(
                  height: 56.0,
                  LeftIconData: Icons.email,
                  title: '消息中心',
                  rightIconData: Icons.chevron_right,
                ),
                Divider(
                    height: 1.8,
                    indent: 0.0,
                    color: Color.fromRGBO(207, 207, 207, 1.0)),
                GestureDetector(
                  onTap: () {
                    //TODO:判断一下是否登录，其实页面跳转需要判断登录应该统一使用路由拦截来实现
                    if (userModel.isLogin) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PersonData();
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginIndex();
                      }));
                    }
                  },
                  child: ListItem(
                    height: 56.0,
                    LeftIconData: Icons.account_circle,
                    title: '个人资料',
                    rightIconData: Icons.chevron_right,
                  ),
                ),
                Divider(
                    height: 1.8,
                    indent: 0.0,
                    color: Color.fromRGBO(207, 207, 207, 1.0)),
                GestureDetector(
                  onTap: () {
                    if (userModel.isLogin) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MySign();
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginIndex();
                      }));
                    }
                  },
                  child: ListItem(
                    height: 56.0,
                    LeftIconData: Icons.import_contacts,
                    title: '我的积分',
                    rightIconData: Icons.chevron_right,
                  ),
                ),

                Divider(
                    height: 1.8,
                    indent: 0.0,
                    color: Color.fromRGBO(207, 207, 207, 1.0)),
                GestureDetector(
                  onTap: () {
                    if (userModel.isLogin) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyOrder();
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginIndex();
                      }));
                    }
                  },
                  child: ListItem(
                    height: 56.0,
                    LeftIconData: Icons.featured_play_list,
                    title: '我的订单',
                    rightIconData: Icons.chevron_right,
                  ),
                ),
                Divider(
                    height: 1.8,
                    indent: 0.0,
                    color: Color.fromRGBO(207, 207, 207, 1.0)),

                Container(
                  height: 56.0,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.brightness_medium,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                '夜间模式',
                                style: TextStyle(
                                    color: Color.fromRGBO(80, 80, 80, 1.0),
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              //单选按钮
                              Switch(
                                value: _switchSelected,
                                onChanged: (value) {
                                  UserModel userModel =
                                      Provider.of<UserModel>(context);
                                  User user1 = Global.user;

                                  //开启关闭夜间模式
                                  setState(() {
                                    _switchSelected = value;
                                  });
                                  if (_switchSelected) {
                                    user1.brightnessStyle = 'dark';
                                    userModel.changeUserInfo(user1);
                                  } else {
                                    user1.brightnessStyle = 'light';
                                    userModel.changeUserInfo(user1);
                                  }
                                  //TODO:调用Global saveUser持久化用户信息
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Divider(
                    height: 1.8,
                    indent: 0.0,
                    color: Color.fromRGBO(207, 207, 207, 1.0)),
              ],
            ),
          ),
          //退出登录按钮
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // 根据用户登录状判断--退出登录还是登录
                    if (userModel.isLogin) {
                      // 退出登录，调用封装的全局静态方法清除持久化的用户信息
                      Global.clearUser();
                      // 使用provide更新状态，通知其他页面
                      User user1 = Global.user;
                      user1.userInfo = null;
                      userModel.changeUserInfo(user1);

                    } 
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginIndex();
                    }));
                  },
                  child: Text(
                    userModel.isLogin ? '退出登录' : '点击登录',
                    style: TextStyle(
                        color: Color.fromRGBO(212, 48, 48, 1.0),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          )
        ],
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
