import 'package:flutter/material.dart';
import 'package:projectpractice/pages/login/LoginByPhone.dart';
import 'package:projectpractice/pages/login/Regist.dart';

class LoginIndex extends StatefulWidget {
  LoginIndex({Key key}) : super(key: key);

// 管理此widget状态和界面的State实例
  @override
  LoginIndexState createState() => LoginIndexState();
}

// 界面状态还有样式的控制
class LoginIndexState extends State<LoginIndex> {
// 构建ui界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/loginbg.png'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Color.fromRGBO(244, 244, 244, .5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 12.0),
                  child: Icon(
                    Icons.clear,
                    color: Color.fromRGBO(86, 83, 83, 1.0),
                    size: 30.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('images/courseLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 120.0),
                            child: Text(
                              '手机号登录',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            color: Color.fromRGBO(51, 177, 123, 1.0),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LoginByPhone();
                              }));
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 128.0),
                              child: Text(
                                '微信登录',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              color: Color.fromRGBO(51, 177, 123, 1.0),
                              onPressed: () {},
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                //TODO:跳转到注册页面
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Regist();
                                }));
                              },
                              child: Text(
                                '手机号快捷注册',
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 177, 123, 1.0),
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                      //  Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 40.0),
                      //   child: Align(
                      //       alignment: Alignment.centerRight,
                      //       child: GestureDetector(
                      //         onTap: () {
                      //         },
                      //         child: Text(
                      //           '忘记密码?',
                      //           style: TextStyle(
                      //               color: Color.fromRGBO(86, 83, 83, 1.0),
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       )),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
          //其他方式登录是位于底部：使用绝对定位布局
          Positioned(
            bottom: 0.0,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 39.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 380.0,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(right: 13.0),
                           width: 100.0,
                           child: Divider(
                                height: 2.5, indent: 0.0, color: Colors.black),
                         ),
                         Container(
                            width: 100.0,
                           child: Text('其他方式登录'),
                         ),
                         Container(
                            width: 110.0,
                           child:  Divider(
                                height: 2.5, indent: 0.0, color: Colors.black),
                         )
                        ],
                      ),
                    ),
                    Container(
                      width: 310.0,
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Image(
                        image: AssetImage('images/weixinlogin.png'),
                      ),
                      )
                      
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
