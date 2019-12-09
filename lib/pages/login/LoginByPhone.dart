import 'package:flutter/material.dart';
import 'package:projectpractice/pages/login/SetPassword.dart';
import 'package:projectpractice/pages/login/LoginByMessage.dart';

class LoginByPhone extends StatefulWidget {
  LoginByPhone({Key key}) : super(key: key);

// 管理此widget状态和界面的State实例
  @override
  LoginByPhoneState createState() => LoginByPhoneState();
}

// 界面状态还有样式的控制
class LoginByPhoneState extends State<LoginByPhone> {
//!登录表单的数据获取和校验使用form提供的相关属性，输入框的数据获取使用form状态实例调用save方法此时
//!调用对应的输入框的onsavae方法里面的参数就是对应的输入框的值了。这样的话就
//!就不用说明控制器了，而是可以直接定义输入框零的字段数据如下：手机号和密码字符串

  //通过全局的key用来获取form表单组件
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //手机号
  String Phone;

  //密码
  String password;

  //点击登录按钮
  void login() {
    //读取当前的form状态
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print(Phone);
      print(password);
    }
  }

// 构建ui界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            '手机号登录',
            style: TextStyle(
                color: Color.fromRGBO(56, 56, 56, 1.0),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Form(
              key: _formKey, //设置globalKey，用于后面获取FormState
              autovalidate: true, //开启自动校验,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(51, 177, 123, 1.0),
                        ),
                        labelText: "手机号",
                        hintText: "请输入手机号",
                        prefixIcon: Icon(Icons.phone_android),
                        //获得焦点输入框下划线设为绿色
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    keyboardType: TextInputType.number, //弹出数字键盘
                    //校验手机号
                    validator: (v) {
                      return v.trim().length > 0 ? null : "手机号不能为空";
                    },
                    //当form表单调用保存方法sava回调函数
                    onSaved: (value) {
                      Phone = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(51, 177, 123, 1.0),
                        ),
                        labelText: "密码",
                        hintText: "请输入密码",
                        prefixIcon: Icon(Icons.lock),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    //检验密码
                    validator: (v) {
                      return v.trim().length > 5 ? null : "密码不能少于6位";
                    },
                    onSaved: (value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  GestureDetector(
                    onTap: () {
                      login();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 10.0),
                      alignment: Alignment.center,
                      height: 45.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.green[600], Colors.green]), //背景渐变
                        borderRadius: BorderRadius.circular(5.0), //3像素圆角
                      ),
                      child: Text(
                        '登录',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SetPassword();
                          }));
                        },
                        child: Text(
                          '忘记密码?',
                          style: TextStyle(
                              color: Color.fromRGBO(86, 83, 83, 1.0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) {
                             return LoginByMessage();
                          }));
                        },
                        child: Text(
                          '短信登录',
                          style: TextStyle(
                              color: Color.fromRGBO(51, 177, 123, 1.0),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))

// This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
