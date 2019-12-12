//进入修改信息页面
import 'package:flutter/material.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'package:projectpractice/models/userInfo.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
class ChangeInfo extends StatefulWidget {
  ChangeInfo({this.id, this.info, this.vary});

  int id;
  String info;
  String vary;
  @override
  _ChangeInfoState createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  //通过全局的key用来获取form表单组件
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  //修改的信息
  String info = '';

  //点击登录按钮
  void login() {
    UserModel userModel = Provider.of<UserModel>(context);
    //读取当前的form状态
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print(info);
      if (widget.vary == '修改昵称') {
        userModel.user.userInfo.petname = info;
      } else if(widget.vary == '修改性别'){
        userModel.user.userInfo.stusex = info;
      } else if(widget.vary == '修改生日'){
        userModel.user.userInfo.birthday = int.parse(info);
      }
      //修改用户信息，传入json对象 ：userInfo转json:tojson
      String infoJson =  json.encode(userModel.user.userInfo);
      var proInfo = json.decode(infoJson);
      Http.postData(
        '/student/updateByPrimaryKey',
        (data){
          print(data);
          var snackBar = SnackBar(
                content: Text('修改成功'),
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
        },
        params:new Map<String, dynamic>.from(proInfo),
        errorCallBack: (error){
          print('error:$error');
        }
      );
      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    info = widget.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  onTap: () {
                    //调用save方法
                    login();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: Text(
                          '保存',
                          style: TextStyle(
                              color: Color.fromRGBO(56, 56, 56, 1.0),
                              fontWeight: FontWeight.bold),
                        ),
                      )))
            ],
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.vary,
                style: TextStyle(
                    color: Color.fromRGBO(56, 56, 56, 1.0),
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Form(
              key: _formKey, //设置globalKey，用于后面获取FormState
              autovalidate: true, //开启自动校验,
              child: Column(
                children: <Widget>[
                  //信息
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(51, 177, 123, 1.0),
                        ),
                        labelText: widget.vary,
                        hintText: info,
                        //获得焦点输入框下划线设为绿色
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    //校验手机号
                    validator: (v) {
                      return v.trim().length > 0 ? null : "${widget.vary}不能为空";
                    },
                    //当form表单调用保存方法sava回调函数
                    onSaved: (value) {
                      info = value;
                    },
                    //当输入内容发生改变的时候调用类似v-model绑定
                    onChanged: (value) {
                      info = value;
                    },
                  ),
                ],
              ),
            )));
  }
}
