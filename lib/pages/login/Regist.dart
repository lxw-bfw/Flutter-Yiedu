import 'package:flutter/material.dart';
import 'dart:async';

//用户注册页面
class Regist extends StatefulWidget {
  Regist({Key key}) : super(key: key);

// 管理此widget状态和界面的State实例
  @override
  RegistState createState() => RegistState();
}

// 界面状态还有样式的控制
class RegistState extends State<Regist> {
  //验证码倒计时定时器
  Timer _timer;
  //验证码倒计时数值
  var countdownTime = 0;

   //通过全局的key用来获取form表单组件
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //手机号
  String Phone;

  //验证码
  String code;

  //密码
  String password;

  //倒计时方法
  startCountdown(){
    countdownTime = 60;
    final call = (timer){
      setState(() {
       if (countdownTime < 1) {
         _timer.cancel();
       } else {
         countdownTime -=1;
       }
      });
     
    };
     _timer = Timer.periodic(Duration(seconds: 1),call);
  }

  //根据倒计时过程返回对应的文本内容
  String handleCodeText(){
    if (countdownTime > 0) {
      return '${countdownTime}s后重新获取';      
    } else {
      return '获取验证码';
    }
  }
  //验证码文本位置的一个控制，倒计时结束与倒计时过程文本内容长度不一样
  double getCodeTextMargin(){
    if (countdownTime > 0) {
      return 270.0;    
    } else {
      return 300.0;
    }
  }
  
 

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
            '注册用户',
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
                  //手机号
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
                    //当输入内容发生改变的时候调用类似v-model绑定
                    onChanged: (value) {
                      Phone = value;
                    },
                  ),
                  //验证码
                  Stack(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(51, 177, 123, 1.0),
                            ),
                            labelText: "验证码",
                            hintText: "请输入验证码",
                            prefixIcon: Icon(Icons.vpn_key),
                            //获得焦点输入框下划线设为绿色
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        keyboardType: TextInputType.number, //弹出数字键盘
                        //校验手机号
                        validator: (v) {
                          return v.trim().length > 0 ? null : "验证码不能为空";
                        },
                        //当form表单调用保存方法sava回调函数
                        onSaved: (value) {
                          code = value;
                        },
                        //当输入内容发生改变的时候调用类似v-model绑定
                        onChanged: (value) {
                          code = value;
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            //TODO:点击获取验证码
                            if (countdownTime == 0) {
                              startCountdown();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(getCodeTextMargin(), 30.0, 0.0, 0.0),
                            child: Text(
                              handleCodeText(),
                              style: TextStyle(
                                  color: Color.fromRGBO(166, 166, 166, 1.0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                  //设置新密码
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
                    onChanged: (value) {
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
                        '确定',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ))

// This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
